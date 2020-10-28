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
  full_name                 = "slo-${local.config.service_name}-${local.config.feature_name}-${local.config.slo_name}"
  pubsub_configs            = [for e in local.exporters : e if lower(e.class) == "pubsub"]
  function_source_directory = var.function_source_directory != "" ? var.function_source_directory : "${path.module}/code"
  suffix                    = random_id.suffix.hex
  requirements_txt = templatefile(
    "${path.module}/code/requirements.txt.tpl", {
      slo_generator_version = var.slo_generator_version
    }
  )
  main_py = templatefile(
    "${path.module}/code/main.py.tpl", {
      slo_config_url          = local.slo_config_url
      error_budget_policy_url = local.error_budget_policy_url
    }
  )
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

data "archive_file" "gcf_code" {
  output_path = "${path.root}/.terraform/code-${local.full_name}.zip"
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
  name   = "gcf/code-${local.full_name}.zip"
  bucket = local.slo_bucket_name
  source = data.archive_file.gcf_code.output_path
}

resource "google_pubsub_topic" "scheduler_topic" {
  project = var.project_id
  name    = "scheduler-topic-${local.full_name}"
  message_storage_policy {
    allowed_persistence_regions = [
      var.region
    ]
  }
}

resource "google_cloud_scheduler_job" "scheduler" {
  project  = var.project_id
  region   = var.region
  name     = "scheduler-job-${local.full_name}"
  schedule = var.schedule
  pubsub_target {
    topic_name = google_pubsub_topic.scheduler_topic.id
    data       = base64encode("test")
  }
}

resource "google_cloudfunctions_function" "function" {
  project               = var.project_id
  region                = var.region
  name                  = local.full_name
  description           = local.config.slo_description
  runtime               = "python37"
  available_memory_mb   = var.function_memory
  source_archive_bucket = local.slo_bucket_name
  source_archive_object = google_storage_bucket_object.archive.name
  entry_point           = "main"
  timeout               = var.function_timeout
  labels                = var.labels
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.scheduler_topic.name
    failure_policy {
      retry = false
    }
  }
  service_account_email         = local.sa_email
  environment_variables         = var.environment_variables
  vpc_connector                 = var.vpc_connector
  vpc_connector_egress_settings = var.vpc_connector_egress_settings
}
