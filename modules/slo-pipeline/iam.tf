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
  service_account_email = length(google_service_account.main) > 0 ? google_service_account.main[0].email : var.service_account_email
}

resource "google_service_account" "main" {
  count        = var.use_custom_service_account ? 0 : 1
  account_id   = var.service_account_name
  project      = var.project_id
  display_name = "Service account for SLO export"
}

resource "google_project_iam_member" "bigquery" {
  count   = var.grant_iam_roles ? length(local.bigquery_configs) : 0
  project = local.bigquery_configs[count.index]["project_id"]
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${local.service_account_email}"
}

resource "google_project_iam_member" "stackdriver" {
  count   = var.grant_iam_roles ? length(local.sd_configs) : 0
  project = local.sd_configs[count.index]["project_id"]
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${local.service_account_email}"
}
