/**
 * Copyright 2022 Google LLC
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
  service_account_email = google_service_account.sre_service_account.email
  sre_config            = yamldecode(file("${path.module}/configs/sre/config.yaml"))
}

module "slo-generator-export" {
  source                = "../../../modules/slo-generator"
  service_name          = "slo-generator-export"
  mode                  = "export"
  project_id            = var.project_id
  region                = var.region
  config                = local.sre_config
  gcr_project_id        = var.gcr_project_id
  slo_generator_version = var.slo_generator_version
  service_account_email = local.service_account_email
  secrets = {
    SRE_PROJECT_ID          = var.project_id
    SRE_BIGQUERY_DATASET_ID = google_bigquery_dataset.export-dataset.dataset_id
  }
  authorized_members = [
    "serviceAccount:${google_service_account.team1_service_account.email}"
  ]
}

resource "google_service_account" "sre_service_account" {
  project      = var.project_id
  account_id   = "slo-generator-export"
  display_name = "SLO Generator Service Account"
}

resource "google_bigquery_dataset" "export-dataset" {
  project       = var.project_id
  dataset_id    = "slos"
  friendly_name = "slos"
  description   = "SLO Reports"
  location      = "EU"
  access {
    role          = "OWNER"
    user_by_email = local.service_account_email
  }
}

resource "google_project_iam_member" "bigquery-writer" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${local.service_account_email}"
}
