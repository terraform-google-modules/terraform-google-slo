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
  account_id   = var.name
  project      = var.project_id
  display_name = "Service account for SLO computations"
}

resource "google_project_iam_member" "stackdriver" {
  count   = var.backend_class == "Stackdriver" ? 1 : 0
  project = var.backend_project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.main.email}"
}

resource "google_pubsub_topic_iam_member" "pubsub" {
  topic   = "projects/${var.pubsub_project_id}/topics/${var.pubsub_topic_name}"
  project = var.pubsub_project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.main.email}"
}

data "template_file" "slo" {
  template = file("${path.module}/code/slo_config.json.tpl")

  vars = {
    service_name        = var.service_name
    feature_name        = var.feature_name
    description         = var.description
    name                = var.name
    target              = var.target
    backend_class       = var.backend_class
    backend_method      = var.backend_method
    backend_project_id  = var.backend_project_id
    backend_measurement = jsonencode(var.backend_measurement)
    pubsub_project_id   = var.pubsub_project_id
    pubsub_topic_name   = var.pubsub_topic_name
  }
}

resource "local_file" "slo" {
  content  = data.template_file.slo.rendered
  filename = "${path.module}/code/slo_config.json"
}

data "template_file" "error_budget_policy" {
  template = file("${path.module}/code/error_budget_policy.json.tpl")
  vars     = {}
}

resource "local_file" "error_budget_policy" {
  content  = data.template_file.error_budget_policy.rendered
  filename = "${path.module}/code/error_budget_policy.json"
}

module "slo-cloud-function" {
  source                                = "github.com/terraform-google-modules/terraform-google-scheduled-function"
  project_id                            = var.project_id
  region                                = var.region
  job_name                              = var.name
  job_schedule                          = var.schedule
  topic_name                            = var.name
  function_name                         = var.name
  function_description                  = var.description
  function_entry_point                  = "main"
  function_source_directory             = "${path.module}/code"
  function_available_memory_mb          = 128
  function_runtime                      = "python37"
  function_source_archive_bucket_labels = var.labels
  function_service_account_email        = google_service_account.main.email
  function_labels                       = var.labels
  bucket_name                           = var.name
}
