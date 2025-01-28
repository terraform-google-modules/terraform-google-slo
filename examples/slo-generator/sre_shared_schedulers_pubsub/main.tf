/**
 * Copyright 2021-2025 Google LLC
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
  config = yamldecode(file("${path.module}/configs/config.yaml"))
  slo_configs = [
    for cfg_path in fileset(path.module, "/configs/slo_*.yaml") :
    yamldecode(file("${path.module}/${cfg_path}"))
  ]
  freqs = {
    "every-minute" : "* * * * *",
    "every-5-minutes" : "*/5 * * * *",
    "every-20-minutes" : "*/20 * * * *"
  }
  frequencies = {
    for name, value in local.freqs :
    name => { frequency : value, names : [for config in local.slo_configs : config.metadata.name if config.spec.frequency == value] }
  }
}

resource "google_cloud_scheduler_job" "scheduler" {
  for_each = { for key, conf in local.frequencies : key => conf if length(conf.names) != 0 }
  project  = var.project_id
  region   = var.region
  schedule = each.value.frequency
  name     = each.key
  http_target {
    oidc_token {
      service_account_email = module.slo-generator.service_account_email
      audience              = module.slo-generator.service_url
    }
    http_method = "POST"
    uri         = "${module.slo-generator.service_url}/?batch=true"
    body        = base64encode(join(";", [for name in each.value.names : "gs://${module.slo-generator.bucket_name}/slos/${name}.yaml"]))
  }
}

module "slo-generator" {
  source  = "terraform-google-modules/slo/google//modules/slo-generator"
  version = "~> 3.0"

  project_id              = var.project_id
  region                  = var.region
  config                  = local.config
  slo_configs             = local.slo_configs
  create_cloud_schedulers = false
  secrets = {
    PROJECT_ID        = var.project_id
    PUBSUB_TOPIC_NAME = google_pubsub_topic.batch.name
  }
  authorized_members = [
    "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  ]
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_pubsub_topic" "batch" {
  name    = "slo-batch"
  project = var.project_id
}

resource "google_pubsub_subscription" "batch" {
  project = var.project_id
  name    = "slo-batch"
  topic   = google_pubsub_topic.batch.id
  push_config {
    push_endpoint = module.slo-generator.service_url
    oidc_token {
      service_account_email = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
    }
  }
}

resource "google_project_iam_member" "pubsub-sa-token-creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}
