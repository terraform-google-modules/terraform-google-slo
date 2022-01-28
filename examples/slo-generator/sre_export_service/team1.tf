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
  team1_config = yamldecode(file("${path.module}/configs/team1/config.yaml"))
  team1_slo_configs = [
    for cfg in fileset(path.module, "/configs/team1/slo_*.yaml") :
    yamldecode(file(cfg))
  ]
}

module "slo-generator" {
  source                = "../../../modules/slo-generator"
  project_id            = var.team1_project_id
  region                = var.region
  config                = local.team1_config
  slo_configs           = local.team1_slo_configs
  gcr_project_id        = var.gcr_project_id
  slo_generator_version = var.slo_generator_version
  service_account_email = google_service_account.team1_service_account.email
  secrets = {
    TEAM1_PROJECT_ID = var.team1_project_id
    SRE_SERVICE_URL = module.slo-generator-export.service_url
    MIN_VALID_EVENTS = 0
  }
}

resource "google_service_account" "team1_service_account" {
  project      = var.team1_project_id
  account_id   = "slo-generator"
  display_name = "SLO Generator Service Account"
}
