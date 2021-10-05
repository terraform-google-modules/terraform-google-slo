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

resource "google_storage_bucket_object" "shared_exporters" {
  count   = length(values(var.exporters)) > 0 ? 1 : 0
  name    = "exporters.yaml"
  content = yamlencode(var.exporters)
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
        env {
          name  = "EXPORTERS_PATH"
          value = "gs://${google_storage_bucket.slos.name}/exporters.yaml"
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
}
