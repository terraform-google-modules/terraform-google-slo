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

locals {
  # Required because TF does not support complex types (optional map args, maps
  # with different types, ...).
  default_exporter_settings = {
    project_id                 = null
    app_key                    = null
    api_key                    = null
    api_token                  = null
    api_url                    = null
    dataset_id                 = null
    table_id                   = null
    topic_name                 = null
    location                   = null
    delete_contents_on_destroy = false
    metrics                    = []
  }
  exporters_pipeline = [
    {
      class      = "Stackdriver"
      project_id = var.stackdriver_host_project_id
    },
    {
      class                      = "Bigquery"
      project_id                 = var.project_id
      dataset_id                 = "slo"
      table_id                   = "reports"
      location                   = "EU"
      delete_contents_on_destroy = true
    }
  ]
  exporters_slo = [
    {
      class      = "Pubsub"
      project_id = module.slo-pipeline.project_id
      topic_name = module.slo-pipeline.pubsub_topic_name
    }  
  ]
  exporters_pipeline_merged = merge(local.default_exporter_settings, local.exporters_pipeline)
  exporters_slo_merged      = merge(local.default_exporter_settings, local.exporters_slo)
}

provider "google" {
  version = "~> 3.19"
}

provider "google-beta" {
  version = "~> 3.19"
}

module "slo-pipeline" {
  source     = "../../../modules/slo-pipeline"
  project_id = var.project_id
  region     = var.region
  exporters  = local.exporters_pipeline_merged
}

module "slo" {
  source     = "../../../modules/slo"
  schedule   = var.schedule
  region     = var.region
  project_id = var.project_id
  labels     = var.labels
  config = {
    slo_name        = "pubsub-ack"
    slo_target      = "0.9"
    slo_description = "Acked Pub/Sub messages over total number of Pub/Sub messages"
    service_name    = "svc"
    feature_name    = "pubsub"
    backend = {
      class      = "Stackdriver"
      method     = "good_bad_ratio"
      project_id = var.stackdriver_host_project_id
      measurement = {
        filter_good = "project=\"${module.slo-pipeline.project_id}\" AND metric.type=\"pubsub.googleapis.com/subscription/ack_message_count\""
        filter_bad  = "project=\"${module.slo-pipeline.project_id}\" AND metric.type=\"pubsub.googleapis.com/subscription/num_outstanding_messages\""
      }
    }
    exporters = local.exporters_slo_merged
  }
}
