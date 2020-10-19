/**
 * Copyright 2019 Google LLC
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
  vars_slo = {
    stackdriver_host_project_id = var.stackdriver_host_project_id
    project_id                  = module.slo-pipeline.project_id
    pubsub_topic_name           = module.slo-pipeline.pubsub_topic_name
  }
  vars_pipeline = {
    project_id                  = var.project_id
    stackdriver_host_project_id = var.stackdriver_host_project_id
  }
}

module "slo-pipeline" {
  source         = "../../../modules/slo-pipeline"
  project_id     = var.project_id
  region         = var.region
  exporters_path = "${path.module}/templates/exporters_pipeline.yaml"
  exporters_vars = local.vars_pipeline
}

module "slo" {
  source                   = "../../../modules/slo"
  schedule                 = var.schedule
  region                   = var.region
  project_id               = var.project_id
  labels                   = var.labels
  config_path              = "${path.module}/templates/slo_pubsub_ack.yaml"
  exporters_path           = "${path.module}/templates/exporters_slo.yaml"
  config_vars              = local.vars_slo
  exporters_vars           = local.vars_slo
  error_budget_policy_path = "${path.module}/templates/error_budget_policy.yaml"
}
