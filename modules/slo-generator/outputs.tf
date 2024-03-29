/**
 * Copyright 2021 Google LLC
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
  value = local.service_url
}

output "service_name" {
  value = var.create_service ? google_cloud_run_service.service[0].name : ""
}

output "bucket_name" {
  value = local.bucket_name
}

output "service_account_email" {
  value = local.service_account_email
}

output "authorized_members" {
  value = google_cloud_run_service_iam_member.run-invokers[*].member
}
