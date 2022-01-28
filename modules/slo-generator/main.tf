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
  signature_type        = var.mode == "compute" ? "http" : "cloudevent"
  service_account_email = var.service_account_email == "" ? "${data.google_project.project.number}-compute@developer.gserviceaccount.com" : var.service_account_email
  bucket_name           = var.bucket_name != "" ? var.bucket_name : "slo-generator-${random_id.suffix.hex}"
  service_url           = var.create_service ? join("", google_cloud_run_service.service[0].status.*.url) : var.service_url
}

resource "random_id" "suffix" {
  byte_length = 6
}

resource "google_storage_bucket" "slos" {
  project       = var.project_id
  name          = local.bucket_name
  location      = var.region
  force_destroy = true
  labels        = var.labels
}

resource "google_storage_bucket_object" "shared_config" {
  name    = "config.yaml"
  content = yamlencode(var.config)
  bucket  = google_storage_bucket.slos.name
}

resource "google_storage_bucket_object" "slos" {
  for_each = { for config in var.slo_configs : config.metadata.name => config }
  name     = "slos/${each.key}.yaml"
  content  = yamlencode(each.value)
  bucket   = google_storage_bucket.slos.name
}

resource "google_cloud_scheduler_job" "scheduler" {
  for_each = { for config in var.slo_configs : config.metadata.name => config }
  project  = var.project_id
  region   = var.region
  schedule = var.schedule
  name     = each.key
  dynamic "pubsub_target" {
    for_each = var.mode == "export" ? ["yes"] : []
    content {
      topic_name = var.pubsub_topic_name
      data       = base64encode("gs://${local.bucket_name}/slos/${each.key}.yaml")
    }
  }
  dynamic "http_target" {
    for_each = var.mode == "compute" ? ["yes"] : []
    content {
      oidc_token {
        service_account_email = local.service_account_email
      }
      http_method = "POST"
      uri         = local.service_url
      body        = base64encode("gs://${local.bucket_name}/slos/${each.key}.yaml")
    }
  }
}

resource "google_cloud_run_service" "service" {
  count                      = var.create_service ? 1 : 0
  name                       = var.service_name
  location                   = var.region
  project                    = var.project_id
  autogenerate_revision_name = true
  provider                   = google-beta

  metadata {
    annotations = {
      "run.googleapis.com/launch-stage" = "BETA"
    }
  }

  template {
    metadata {
      annotations = var.annotations
      labels      = var.labels
    }
    spec {
      service_account_name = local.service_account_email
      containers {
        image   = "gcr.io/${var.gcr_project_id}/slo-generator:${var.slo_generator_version}"
        command = ["slo-generator"]
        args = [
          "api",
          "--signature-type=${local.signature_type}",
          "--target=run_${var.mode}"
        ]
        env {
          name  = "CONFIG_PATH"
          value = "gs://${google_storage_bucket.slos.name}/config.yaml"
        }
        dynamic "env" {
          for_each = google_secret_manager_secret.secret
          content {
            name = env.value.secret_id
            value_from {
              secret_key_ref {
                name = env.value.secret_id
                key  = "latest"
              }
            }
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_iam_member.sa-roles,
    google_secret_manager_secret_version.secret-version-data
  ]
}
