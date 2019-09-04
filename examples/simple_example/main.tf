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
  credentials = file(var.credentials_path)
  version = "~> 2.0"
}

module "slo-project" {
  source                     = "terraform-google-modules/project-factory/google"
  version                    = "~> 3.0.0"
  random_project_id          = "true"
  name                       = var.project_name
  org_id                     = var.org_id
  folder_id                  = var.folder_id
  billing_account            = var.billing_account
  credentials_path           = var.credentials_path
  auto_create_network        = "true"
  disable_dependent_services = "true"
  labels                     = var.labels

  activate_apis = [
    "appengine.googleapis.com",
    "pubsub.googleapis.com",
    "bigquery-json.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudscheduler.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ]
}

# TODO: Add project to Stackdriver host workspace here

module "slo-pipeline" {
  source                      = "../../modules/slo-pipeline"
  function_name               = "slo-export"
  region                      = var.region
  project_id                  = module.slo-project.project_id
  bigquery_project_id         = module.slo-project.project_id
  bigquery_dataset_name       = "slo_reports"
  bucket_name                 = var.bucket_name
  stackdriver_host_project_id = var.stackdriver_host_project_id
}

module "slo" {
  source             = "../../modules/slo"
  name               = "pubsub-acked-msg"
  region             = "${var.region}1"
  description        = "Acked Pub/Sub messages over total number of Pub/Sub messages"
  service_name       = "test"
  feature_name       = "test"
  target             = "0.9"
  backend_class      = "Stackdriver"
  backend_project_id = "rnm-shared-monitoring"
  backend_method     = "good_bad_ratio"
  backend_measurement = {
    filter_good = "project=\"${module.slo-pipeline.project_id}\" AND metric.type=\"pubsub.googleapis.com/subscription/ack_message_count\"",
    filter_bad  = "project=\"${module.slo-pipeline.project_id}\" AND metric.type=\"pubsub.googleapis.com/subscription/ack_message_count\""
  }
  schedule          = "* * * * */1"
  project_id        = module.slo-project.project_id
  pubsub_project_id = module.slo-pipeline.project_id
  pubsub_topic_name = module.slo-pipeline.pubsub_topic_name
  labels            = var.labels
}
