/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
  version = "~> 3.19"
}

provider "google-beta" {
  version = "~> 3.19"
}

locals {
  // Load error budget policy
  error_budget_policy = yamldecode(file("templates/error_budget_policy.yaml"))

  // Load exporters for pipeline and SLOs
  exporters = yamldecode(templatefile("templates/exporters.yaml",
    {
      stackdriver_host_project_id = var.stackdriver_host_project_id,
      project_id                  = var.project_id,
      pubsub_topic_name           = module.slo-pipeline.pubsub_topic_name
  }))

  // Load all SLO configs in the templates/ folder, replace template variables
  // and merge with SLO exporter config in exporters.yaml.
  slo_configs = [
    for file in fileset(path.module, "/templates/slo_*.yaml") :
    merge(yamldecode(templatefile(file,
      {
        stackdriver_host_project_id = var.stackdriver_host_project_id,
        project_id                  = var.project_id,
      })), {
      exporters = local.exporters.slo
    })
  ]
  slo_config_map = { for config in local.slo_configs : "${config.service_name}-${config.feature_name}-${config.slo_name}" => config }
}

resource "google_service_account" "slo-generator" {
  project      = var.project_id
  display_name = "SLO Generator Service Account"
  account_id   = "slo-generator"
}

resource "google_storage_bucket" "slos" {
  project  = var.project_id
  location = "EU"
  name     = var.bucket_name
}

module "slo-pipeline" {
  source         = "../../../modules/slo-pipeline"
  project_id     = var.project_id
  region         = var.region
  exporters      = local.exporters.pipeline
  dataset_create = false
}

module "slo-generator-bq-latency" {
  source                     = "../../../modules/slo"
  schedule                   = var.schedule
  region                     = var.region
  project_id                 = var.project_id
  labels                     = var.labels
  config                     = local.slo_config_map["generator-bq-latency"]
  error_budget_policy        = local.error_budget_policy
  config_bucket              = google_storage_bucket.slos.name
  use_custom_service_account = true
  service_account_email      = google_service_account.slo-generator.email
}

module "slo-generator-gcf-errors" {
  source                     = "../../../modules/slo"
  schedule                   = var.schedule
  region                     = var.region
  project_id                 = var.project_id
  labels                     = var.labels
  config                     = local.slo_config_map["generator-gcf-errors"]
  error_budget_policy        = local.error_budget_policy
  config_bucket              = google_storage_bucket.slos.name
  use_custom_service_account = true
  service_account_email      = google_service_account.slo-generator.email
}

module "slo-generator-pubsub-ack" {
  source                     = "../../../modules/slo"
  schedule                   = var.schedule
  region                     = var.region
  project_id                 = var.project_id
  labels                     = var.labels
  config                     = local.slo_config_map["generator-pubsub-ack"]
  error_budget_policy        = local.error_budget_policy
  config_bucket              = google_storage_bucket.slos.name
  use_custom_service_account = true
  service_account_email      = google_service_account.slo-generator.email
}