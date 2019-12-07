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
  exporters_hash            = substr(sha256(local_file.exporters.content), 0, 2)
  function_source_directory = var.function_source_directory != "" ? var.function_source_directory : "${path.module}/code"
  cf_suffix                 = "${substr(random_uuid.config_hash.result, 0, 2)}${substr(exporters_hash, 0, 2)}"
}

resource "google_pubsub_topic" "stream" {
  project = var.project_id
  name    = var.pubsub_topic_name
}

resource "local_file" "exporters" {
  content  = jsonencode(var.exporters)
  filename = "${path.module}/code/exporters.json"
}

# Generate a random uuid that will regenerate when one of the file in the source
# directory is updated.
resource "random_uuid" "code_hash" {
  keepers = {
    for filename in fileset("${path.module}/code", "**/*") :
    filename => filemd5("${local.function_source_directory}/${filename}")
  }
}

# Regenerate the archive whenever one of the Cloud Function code files, SLO
# config or Error Budget policy is updated.
data "archive_file" "main" {
  type        = "zip"
  output_path = pathexpand("code-pipeline-${local.cf_suffix}.zip")
  source_dir  = pathexpand(local.function_source_directory)
  depends_on = [
    local_file.exporters
  ]
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

resource "google_storage_bucket" "bucket" {
  name    = var.bucket_name
  project = var.project_id
}

resource "google_storage_bucket_object" "main" {
  name                = "slo_exporter.zip"
  bucket              = google_storage_bucket.bucket.name
  source              = data.archive_file.main.output_path
  content_disposition = "attachment"
  content_encoding    = "gzip"
  content_type        = "application/zip"
}

resource "google_cloudfunctions_function" "function" {
  description           = "SLO Exporter to BigQuery or Stackdriver Monitoring"
  name                  = var.function_name
  available_memory_mb   = var.function_memory
  project               = var.project_id
  region                = var.region
  service_account_email = local.service_account_email
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.main.name
  runtime               = "python37"
  timeout               = "60"
  entry_point           = "main"
  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = "projects/${var.project_id}/topics/${google_pubsub_topic.stream.name}"
  }
}
