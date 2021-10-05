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
    "roles/storage.objectViewer",
    google_project_iam_custom_role.bucket-reader.id
  ], var.additional_project_roles)
}

resource "google_project_iam_custom_role" "bucket-reader" {
  project     = var.project_id
  role_id     = "BucketAccessor"
  title       = "Bucket accessor"
  description = "Bucket accessor"
  permissions = ["storage.buckets.get"]
}

resource "google_project_iam_member" "sa-roles" {
  count   = var.create_iam_roles ? length(local.roles) : 0
  project = var.project_id
  role    = local.roles[count.index]
  member  = "serviceAccount:${local.service_account_email}"
}
