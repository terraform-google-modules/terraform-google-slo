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
  version     = "~> 2.0"
}

module "slo-pipeline" {
  source        = "../../modules/slo-pipeline"
  project_id    = var.project_id
  function_name = var.function_name
  bucket_name   = var.bucket_name
  region        = var.region
  exporters = [
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
}

module "slo" {
  source     = "../../modules/slo"
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
    exporters = [
      {
        class      = "Pubsub"
        project_id = module.slo-pipeline.project_id
        topic_name = module.slo-pipeline.pubsub_topic_name
      }
    ]
  }
}
