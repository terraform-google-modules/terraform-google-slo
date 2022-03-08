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


locals {
  roles = concat([
    "roles/monitoring.viewer",
    "roles/monitoring.metricWriter",
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor",
    "roles/storage.admin",
  ], var.additional_project_roles)
}

resource "google_project_iam_member" "sa-roles" {
  count   = var.create_iam_roles ? length(local.roles) : 0
  project = var.project_id
  role    = local.roles[count.index]
  member  = "serviceAccount:${local.service_account_email}"
}

resource "google_cloud_run_service_iam_member" "run-invokers" {
  count    = var.create_iam_roles ? length(var.authorized_members) : 0
  location = google_cloud_run_service.service[0].location
  project  = google_cloud_run_service.service[0].project
  service  = google_cloud_run_service.service[0].name
  role     = "roles/run.invoker"
  member   = var.authorized_members[count.index]
}
