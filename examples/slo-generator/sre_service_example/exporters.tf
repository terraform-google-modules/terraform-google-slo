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

# Pubsub topic to export SLOs to
resource "google_pubsub_topic" "export-topic" {
  project = var.project_id
  name    = var.pubsub_topic_name
}

resource "google_pubsub_topic_iam_member" "pubsub-publisher" {
  project = google_pubsub_topic.export-topic.project
  topic   = google_pubsub_topic.export-topic.name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${local.service_account_email}"
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
}
