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
  full_name                 = "slo-${var.config.service_name}-${var.config.feature_name}-${var.config.slo_name}"
  pubsub_configs            = [for e in var.config.exporters : e if lower(e.class) == "pubsub"]
  service_account_email     = var.service_account_email != "" ? var.service_account_email : google_service_account.main[0].email
  bucket_suffix             = random_id.suffix.hex
  function_source_directory = var.function_source_directory != "" ? var.function_source_directory : "${path.module}/code"

  # Cloud Function suffix so that it updates on code / config change
  cf_suffix = "${substr(random_uuid.config_hash.result, 0, 2)}${substr(random_uuid.config_hash.result, 0, 2)}"
}

resource "random_id" "suffix" {
  byte_length = 2
}

resource "local_file" "slo" {
  content  = jsonencode(var.config)
  filename = "${path.module}/code/slo_config.json"
}

resource "local_file" "error_budget_policy" {
  content  = jsonencode(var.error_budget_policy)
  filename = "${path.module}/code/error_budget_policy.json"
}

# Temporary code to replace module invocation (see bottom of this file) until
# https://github.com/terraform-google-modules/terraform-google-event-function/issues/37
# is fixed.
resource "google_cloud_scheduler_job" "job" {
  name        = local.full_name
  project     = var.project_id
  region      = var.region
  description = var.config.slo_description
  schedule    = var.schedule
  time_zone   = var.time_zone

  pubsub_target {
    topic_name = "projects/${var.project_id}/topics/${module.pubsub_topic.topic}"
    data       = var.message_data
  }
}

module "pubsub_topic" {
  source     = "terraform-google-modules/pubsub/google"
  version    = "~> 1.0"
  project_id = var.project_id
  topic      = local.full_name
}

# Generate a random uuid that will regenerate when one of the file in the source
# directory is updated.
resource "random_uuid" "code_hash" {
  keepers = {
    for filename in fileset(local.function_source_directory, "**/*") :
    filename => filemd5("${local.function_source_directory}/${filename}")
  }
}

# Generate a random uuid that will regenerate when the SLO config or the Error
# Budget Policy is updated.
# Workaround for https://github.com/terraform-providers/terraform-provider-random/issues/95
resource "random_uuid" "config_hash" {
  keepers = {
    for content in [local_file.slo.content, local_file.error_budget_policy.content] :
    content => md5(content)
  }
}

# Regenerate the archive whenever one of the Cloud Function code files, SLO
# config or Error Budget policy is updated.
data "archive_file" "main" {
  type        = "zip"
  output_path = pathexpand("code-${local.full_name}-${local.cf_suffix}.zip")
  source_dir  = pathexpand(local.function_source_directory)
  depends_on = [
    local_file.slo,
    local_file.error_budget_policy
  ]
}

resource "google_storage_bucket" "main" {
  name          = "${local.full_name}-${local.bucket_suffix}"
  force_destroy = var.bucket_force_destroy
  location      = var.region
  project       = var.project_id
  storage_class = "REGIONAL"
  labels        = var.labels
}

resource "google_storage_bucket_object" "main" {
  name                = "code-${local.full_name}-${local.cf_suffix}"
  bucket              = google_storage_bucket.main.name
  source              = data.archive_file.main.output_path
  content_disposition = "attachment"
  content_encoding    = "gzip"
  content_type        = "application/zip"
}

resource "google_cloudfunctions_function" "main" {
  name                  = "${local.full_name}-${local.cf_suffix}"
  description           = var.config.slo_description
  available_memory_mb   = 128
  timeout               = var.function_timeout_s
  entry_point           = "main"
  labels                = var.labels
  runtime               = "python37"
  environment_variables = var.function_environment_variables
  source_archive_bucket = google_storage_bucket.main.name
  source_archive_object = google_storage_bucket_object.main.name
  project               = var.project_id
  region                = var.region
  service_account_email = local.service_account_email

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = module.pubsub_topic.topic
  }
}

# Replace below code by this once https://github.com/terraform-google-modules/terraform-google-event-function/issues/37
# is fixed.
# module "slo-cloud-function" {
#   source                                = "github.com/terraform-google-modules/terraform-google-scheduled-function"
#   project_id                            = var.project_id
#   region                                = var.region
#   job_schedule                          = var.schedule
#   job_name                              = local.full_name
#   topic_name                            = local.full_name
#   bucket_name                           = "${local.full_name}-${local.bucket_suffix}"
#   function_name                         = "${local.full_name}-${local.cf_suffix}"
#   function_description                  = var.config.slo_description
#   function_entry_point                  = "main"
#   function_source_directory             = "${path.module}/code"
#   function_available_memory_mb          = 128
#   function_runtime                      = "python37"
#   function_source_archive_bucket_labels = var.labels
#   function_service_account_email        = local.service_account_email
#   function_labels                       = var.labels
# }
