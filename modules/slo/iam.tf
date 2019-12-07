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
  count        = var.service_account_email != "" ? 0 : 1
  account_id   = local.full_name
  project      = var.project_id
  display_name = "Service account for SLO computations"
}

resource "google_project_iam_member" "stackdriver" {
  count   = var.grant_iam_roles && var.config.backend.class == "Stackdriver" ? 1 : 0
  project = var.config.backend.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${local.service_account_email}"
}

resource "google_pubsub_topic_iam_member" "pubsub" {
  count   = var.grant_iam_roles ? length(local.pubsub_configs) : 0
  topic   = local.pubsub_configs[count.index].topic_name
  project = local.pubsub_configs[count.index].project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${local.service_account_email}"
}
