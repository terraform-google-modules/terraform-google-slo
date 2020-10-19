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
  error_budget_policy_path = "${path.root}/templates/error_budget_policy.yaml"
  exporters_path_pipeline  = "${path.root}/templates/exporters_pipeline.yaml"
  exporters_path_slo       = "${path.root}/templates/exporters_slo.yaml"
  slo_configs_paths        = tolist(fileset(path.root, "/templates/slo_*.yaml"))
  exporters_vars_pipeline = {
    stackdriver_host_project_id = var.stackdriver_host_project_id
    project_id                  = var.project_id
  }
  exporters_vars_slo = {
    project_id        = module.slo-pipeline.project_id
    pubsub_topic_name = module.slo-pipeline.pubsub_topic_name
  }
  slo_configs_vars = {
    stackdriver_host_project_id = var.stackdriver_host_project_id
    project_id                  = var.project_id
  }
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
  exporters_path = local.exporters_path_pipeline
  exporters_vars = local.exporters_vars_pipeline
}

module "slo-generator-bq-latency" {
  source                     = "../../../modules/slo"
  schedule                   = var.schedule
  region                     = var.region
  project_id                 = var.project_id
  labels                     = var.labels
  use_custom_service_account = true
  service_account_email      = google_service_account.slo-generator.email
  config_bucket              = google_storage_bucket.slos.name
  config_path                = local.slo_configs_paths[0]
  config_vars                = local.slo_configs_vars
  exporters_path             = local.exporters_path_slo
  exporters_vars             = local.exporters_vars_slo
  error_budget_policy_path   = local.error_budget_policy_path
}

module "slo-generator-gcf-errors" {
  source                     = "../../../modules/slo"
  schedule                   = var.schedule
  region                     = var.region
  project_id                 = var.project_id
  labels                     = var.labels
  use_custom_service_account = true
  service_account_email      = google_service_account.slo-generator.email
  config_bucket              = google_storage_bucket.slos.name
  config_path                = local.slo_configs_paths[1]
  config_vars                = local.slo_configs_vars
  exporters_path             = local.exporters_path_slo
  exporters_vars             = local.exporters_vars_slo
  error_budget_policy_path   = local.error_budget_policy_path
}

module "slo-generator-pubsub-ack" {
  source                     = "../../../modules/slo"
  schedule                   = var.schedule
  region                     = var.region
  project_id                 = var.project_id
  labels                     = var.labels
  use_custom_service_account = true
  service_account_email      = google_service_account.slo-generator.email
  config_bucket              = google_storage_bucket.slos.name
  config_path                = local.slo_configs_paths[2]
  config_vars                = local.slo_configs_vars
  exporters_path             = local.exporters_path_slo
  exporters_vars             = local.exporters_vars_slo
  error_budget_policy_path   = local.error_budget_policy_path
}
