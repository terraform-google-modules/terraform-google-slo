/**
 * Copyright 2021-2024 Google LLC
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

output "service_url" {
  description = "The URL of the service"
  value       = local.service_url
}

output "service_name" {
  description = "The name of the service"
  value       = var.create_service ? google_cloud_run_service.service[0].name : ""
}

output "bucket_name" {
  description = "The name of the bucket"
  value       = local.bucket_name
}

output "service_account_email" {
  description = "The email of the service account"
  value       = local.service_account_email
}

output "authorized_members" {
  description = "The authorized members"
  value       = google_cloud_run_service_iam_member.run-invokers[*].member
}
