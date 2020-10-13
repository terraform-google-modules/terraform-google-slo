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
  suffix                    = random_id.suffix.hex
  function_source_directory = var.function_source_directory != "" ? var.function_source_directory : "${path.root}/.terraform"
  function_target_directory = "${local.function_source_directory}/code_${local.suffix}"
  requirements_txt = templatefile(
    "${path.module}/code/requirements.txt.tpl", {
      slo_generator_version = var.slo_generator_version
    }
  )
  main_py = templatefile(
    "${path.module}/code/main.py.tpl", {
      slo_config_gcs_filepath          = "gs://${var.configs_bucket_name}/${google_storage_bucket_object.slo_config.output_name}"
      error_budget_policy_gcs_filepath = "gs://${var.configs_bucket_name}/${google_storage_bucket_object.error_budget_policy.output_name}"
    }
  )
  existing_dir = fileexists("${local.function_target_directory}/main.py")
}

resource "random_id" "suffix" {
  byte_length = 6
}

resource "google_storage_bucket_object" "slo_config" {
  name    = "${local.full_name}/slo_config.json"
  content = jsonencode(var.config)
  bucket  = var.configs_bucket_name
}

resource "google_storage_bucket_object" "error_budget_policy" {
  name    = "${local.full_name}/error_budget_policy.json"
  content = jsonencode(var.config) 
  bucket  = var.configs_bucket_name
}

resource "local_file" "main_py" {
  content  = local.main_py
  filename = "${local.function_target_directory}/main.py"
}

resource "local_file" "requirements_txt" {
  content  = local.requirements_txt
  filename = "${local.function_target_directory}/requirements.txt"
}

module "slo_cloud_function" {
  source  = "terraform-google-modules/scheduled-function/google"
  version = "~> 1.5.1"
  project_id                = var.project_id
  region                    = var.region
  job_schedule              = var.schedule
  job_name                  = local.full_name
  topic_name                = local.full_name
  bucket_name               = "${local.full_name}-${local.suffix}"
  bucket_force_destroy      = "true"
  function_name             = "${local.full_name}-${local.suffix}"
  function_description      = var.config.slo_description
  function_entry_point      = "main"
  function_source_directory = local.function_target_directory
  function_source_dependent_files = [
    local_file.requirements_txt,
    local_file.main_py
  ]
  function_available_memory_mb          = 128
  function_runtime                      = "python37"
  function_source_archive_bucket_labels = var.labels
  function_service_account_email        = local.sa_email
  function_labels                       = var.labels
}