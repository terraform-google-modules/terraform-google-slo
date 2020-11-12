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
  requirements_txt = templatefile(
    "${path.module}/code/requirements.txt.tpl", {
      slo_generator_version = var.slo_generator_version
    }
  )
  main_py = templatefile(
    "${path.module}/code/main.py.tpl", {
      exporters_url = local.exporters_url
    }
  )
  dataset_expiration = var.dataset_default_table_expiration_ms == -1 ? null : var.dataset_default_table_expiration_ms
  default_files = [
    {
      content  = local.requirements_txt
      filename = "requirements.txt"
    },
    {
      content  = local.main_py
      filename = "main.py"
    }
  ]
  files = concat(local.default_files, var.extra_files)
}

resource "random_id" "suffix" {
  byte_length = 6
}

resource "google_pubsub_topic" "stream" {
  project = var.project_id
  name    = var.pubsub_topic_name
}

data "archive_file" "gcf_code" {
  output_path = "${path.root}/.terraform/code-pipeline.zip"
  type        = "zip"
  dynamic "source" {
    for_each = local.files
    content {
      content  = source.value["content"]
      filename = source.value["filename"]
    }
  }
}

resource "google_storage_bucket_object" "archive" {
  name   = "gcf/code-pipeline.zip"
  bucket = local.bucket_name
  source = data.archive_file.gcf_code.output_path
}

resource "google_cloudfunctions_function" "function" {
  project               = var.project_id
  region                = var.region
  name                  = var.function_name
  description           = "SLO Exporter Pipeline"
  runtime               = "python37"
  available_memory_mb   = var.function_memory
  source_archive_bucket = local.bucket_name
  source_archive_object = google_storage_bucket_object.archive.name
  entry_point           = "main"
  timeout               = var.function_timeout
  labels                = var.labels
  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.stream.id
    failure_policy {
      retry = false
    }
  }
  service_account_email         = local.service_account_email
  environment_variables         = var.function_environment_variables
  vpc_connector                 = var.vpc_connector
  vpc_connector_egress_settings = var.vpc_connector_egress_settings
}
