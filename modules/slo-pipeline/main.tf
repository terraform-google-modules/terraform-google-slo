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
  function_source_directory = var.function_source_directory != "" ? var.function_source_directory : "${path.module}/code"
  bucket_suffix             = random_id.suffix.hex
  bucket_name               = "${var.function_bucket_name}-${local.bucket_suffix}"
}

resource "random_id" "suffix" {
  byte_length = 2
}

resource "google_pubsub_topic" "stream" {
  project = var.project_id
  name    = var.pubsub_topic_name
}

resource "local_file" "exporters" {
  content  = jsonencode(var.exporters)
  filename = "${path.module}/code/exporters.json"
}

resource "google_bigquery_dataset" "main" {
  count                       = length(local.bigquery_configs)
  project                     = local.bigquery_configs[count.index].project_id
  dataset_id                  = local.bigquery_configs[count.index].dataset_id
  delete_contents_on_destroy  = lookup(local.bigquery_configs[count.index], "delete_contents_on_destroy", false)
  location                    = lookup(local.bigquery_configs[count.index], "location", "EU")
  friendly_name               = "SLO Reports"
  description                 = "Table storing SLO reports from SLO reporting pipeline"
  default_table_expiration_ms = 525600000 # 1 year
}

module "event_function" {
  # TODO update version once event-function is released with new functionality
  source = "github.com/taylorludwig/terraform-google-event-function?ref=feature%2F37-terraform-created-files-in-archive"
  # source  = "terraform-google-modules/event-function/google"
  # version = "~> 1.1"

  description            = "SLO Exporter to BigQuery or Stackdriver Monitoring"
  name                   = var.function_name
  available_memory_mb    = var.function_memory
  project_id             = var.project_id
  region                 = var.region
  service_account_email  = local.service_account_email
  source_directory       = local.function_source_directory
  source_dependent_files = [local_file.exporters]
  bucket_name            = local.bucket_name
  runtime                = "python37"
  timeout_s              = "60"
  entry_point            = "main"

  event_trigger = {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = "projects/${var.project_id}/topics/${google_pubsub_topic.stream.name}"
  }
}
