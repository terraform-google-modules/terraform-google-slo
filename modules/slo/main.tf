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
  function_source_directory = var.function_source_directory != "" ? var.function_source_directory : "${path.module}/code"
  function_target_directory = "${path.module}/code_${local.suffix}"
  requirements_txt = templatefile(
    "${path.module}/code/requirements.txt.tpl", {
      slo_generator_version = var.slo_generator_version
    }
  )
}

resource "null_resource" "copy_gcf_folder" {
  triggers = { suffix = local.function_target_directory }
  provisioner "local-exec" {
    command = "mkdir -p ${local.function_target_directory} && cp -R ${local.function_source_directory}/* ${local.function_target_directory}"
  }
}

resource "random_id" "suffix" {
  byte_length = 6
}

resource "local_file" "requirements_txt" {
  content  = local.requirements_txt
  filename = "${local.function_target_directory}/requirements.txt"
}

resource "local_file" "slo" {
  content  = jsonencode(var.config)
  filename = "${local.function_target_directory}/slo_config.json"
}

resource "local_file" "error_budget_policy" {
  content  = jsonencode(var.error_budget_policy)
  filename = "${local.function_target_directory}/error_budget_policy.json"
}

resource "local_file" "info_file" {
  content  = "Suffix: ${local.suffix}\nId: ${null_resource.copy_gcf_folder.id}"
  filename = "${local.function_target_directory}/info.txt"
}

module "slo_cloud_function" {
  source  = "terraform-google-modules/scheduled-function/google"
  version = "~> 1.3"

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
    local_file.error_budget_policy,
    local_file.slo,
    local_file.requirements_txt,
    local_file.info_file
  ]
  function_available_memory_mb          = 128
  function_runtime                      = "python37"
  function_source_archive_bucket_labels = var.labels
  function_service_account_email        = local.sa_email
  function_labels                       = var.labels
}
