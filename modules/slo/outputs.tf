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

output "project_id" {
  description = "Project id"
  value       = var.project_id
}

output "config" {
  description = "SLO Config"
  value       = var.config
}

output "service_account_email" {
  description = "Service account email used to run the Cloud Function"
  value       = local.service_account_email
}

output "scheduler_job_name" {
  description = "Cloud Scheduler job name"
  value       = module.slo_cloud_function.name
}

output "function_zip_output_path" {
  description = "Cloud Function zip output path"
  value       ="${local.function_source_directory}.zip"
}
