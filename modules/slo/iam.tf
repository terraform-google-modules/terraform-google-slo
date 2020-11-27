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
  sa_name            = var.service_account_name != "" ? var.service_account_name : local.full_name
  sa_email           = length(google_service_account.main) > 0 ? google_service_account.main[0].email : var.service_account_email
  ssm_class          = var.config.backend.class == "StackdriverServiceMonitoring"
  ssm_project_id     = lookup(lookup(lookup(var.config.backend, "measurement", {}), "cluster_istio", {}), "project_id", "")
  sd_class           = var.config.backend.class == "Stackdriver"
  backend_project_id = lookup(var.config.backend, "project_id", null)
}

resource "google_service_account" "main" {
  count        = var.use_custom_service_account ? 0 : 1
  account_id   = local.sa_name
  project      = var.project_id
  display_name = "Service account for SLO computations"
}

resource "google_project_iam_member" "stackdriver" {
  count   = var.grant_iam_roles && (local.sd_class || local.ssm_class) ? 1 : 0
  project = local.backend_project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${local.sa_email}"
}

resource "google_project_iam_member" "stackdriver-ssm-svc-editor" {
  count   = var.grant_iam_roles && local.ssm_class ? 1 : 0
  project = local.backend_project_id
  role    = "roles/monitoring.servicesEditor"
  member  = "serviceAccount:${local.sa_email}"
}

resource "google_project_iam_member" "stackdriver-ssm-svc-viewer" {
  count   = var.grant_iam_roles && local.ssm_class && local.ssm_project_id != "" ? 1 : 0
  project = local.ssm_project_id
  role    = "roles/monitoring.servicesViewer"
  member  = "serviceAccount:${local.sa_email}"
}

resource "google_project_iam_member" "logs-writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${local.sa_email}"
}

resource "google_pubsub_topic_iam_member" "pubsub" {
  count   = var.grant_iam_roles ? length(local.pubsub_configs) : 0
  topic   = local.pubsub_configs[count.index].topic_name
  project = local.pubsub_configs[count.index].project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${local.sa_email}"
}

resource "google_storage_bucket_iam_member" "object-viewer" {
  count  = var.grant_iam_roles ? 1 : 0
  bucket = local.slo_bucket_name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${local.sa_email}"
}

resource "google_storage_bucket_iam_member" "object-viewer-legacy" {
  count  = var.grant_iam_roles ? 1 : 0
  bucket = local.slo_bucket_name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${local.sa_email}"
}
