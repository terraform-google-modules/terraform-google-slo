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
  service_account_email = google_service_account.service_account.email
  sre_config            = yamldecode(file("${path.module}/configs/sre/config.yaml"))
  sre_slo_configs = [
    for cfg in fileset(path.module, "/configs/sre/slo_*.yaml") :
    yamldecode(file(cfg))
  ]
}

# SLOs as-a-service, run by SRE team.
# This service can be used by the various teams to compute their SLOs.
module "slo-generator" {
  source                = "../../../modules/slo-generator"
  project_id            = var.project_id
  region                = var.region
  config                = local.sre_config
  service_account_email = local.service_account_email
  slo_configs           = local.sre_slo_configs
  gcr_project_id        = var.gcr_project_id
  slo_generator_version = var.slo_generator_version
  secrets = {
    SRE_PROJECT_ID          = var.project_id
    SRE_BIGQUERY_DATASET_ID = google_bigquery_dataset.export-dataset.dataset_id
    TEAM2_PROJECT_ID        = var.team2_project_id
  }
  authorized_members = [
    "serviceAccount:${module.team2-slos.service_account_email}"
  ]
}

# BigQuery dataset to export SLOs to
resource "google_bigquery_dataset" "export-dataset" {
  project       = var.project_id
  dataset_id    = var.bigquery_dataset_name
  friendly_name = "slos"
  description   = "SLO Reports"
  location      = "EU"
  access {
    role          = "OWNER"
    user_by_email = local.service_account_email
  }
  access {
    role          = "roles/bigquery.dataEditor"
    user_by_email = module.team1-slos.service_account_email
  }
}

# SRE SA for slo-generator service
resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = "slo-generator"
  display_name = "SLO Generator Service Account"
}

# SRE SA service account needs to be able to read GCS configs in team2's GCS bucket
resource "google_storage_bucket_iam_member" "storage-admin" {
  bucket = module.team2-slos.bucket_name
  role   = "roles/storage.admin"
  member = "serviceAccount:${local.service_account_email}"
}

# SRE SA needs to read metrics from Cloud Ops workspace in team2's project
resource "google_project_iam_member" "monitoring-viewer" {
  project = var.team2_project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${local.service_account_email}"
}

# SRE SA needs to write metrics to Cloud Ops workspace in team2's project
resource "google_project_iam_member" "monitoring-metric-writer" {
  project = var.team2_project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${local.service_account_email}"
}
