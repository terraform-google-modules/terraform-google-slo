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
 
resource "google_service_account" "main" {
  account_id   = "slo-exporter"
  project      = var.project_id
  display_name = "Service account for SLO export"
}

resource "google_project_iam_member" "bigquery" {
  project = var.bigquery_project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.main.email}"
}

resource "google_project_iam_member" "stackdriver" {
  project = var.stackdriver_host_project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.main.email}"
}
