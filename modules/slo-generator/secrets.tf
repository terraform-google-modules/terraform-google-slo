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
 
data "google_project" "project" {
  project_id = var.project_id
}

resource "google_secret_manager_secret" "secret" {
  for_each  = var.secrets
  provider  = google-beta
  project   = var.project_id
  secret_id = each.key
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_iam_member" "secret-access" {
  for_each  = google_secret_manager_secret.secret
  provider  = google-beta
  project   = var.project_id
  secret_id = each.value.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${local.service_account_email}"
}

resource "google_secret_manager_secret_version" "secret-version-data" {
  for_each    = google_secret_manager_secret.secret
  provider    = google-beta
  secret      = each.value.id
  secret_data = var.secrets[each.key]
}


