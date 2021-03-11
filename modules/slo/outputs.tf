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

output "error_budget_policy" {
  description = "Error budget policy config"
  value       = var.error_budget_policy
}

output "service_account_email" {
  description = "Service account email used to run the Cloud Function"
  value       = local.sa_email
}

output "scheduler_job_name" {
  description = "Cloud Scheduler job name"
  value       = google_cloud_scheduler_job.scheduler.name
}

output "function_name" {
  description = "Cloud Function name"
  value       = google_cloudfunctions_function.function.name
}

output "function_bucket_name" {
  description = "Cloud Function bucket name"
  value       = local.slo_bucket_name
}

output "function_zip_output_path" {
  description = "Cloud Function zip output path"
  value       = "${local.function_source_directory}.zip"
}

output "slo_config_url" {
  description = "SLO Config GCS URL"
  value       = local.slo_config_url
}

output "error_budget_policy_url" {
  description = "Error budget policy GCS URL"
  value       = local.error_budget_policy_url
}
