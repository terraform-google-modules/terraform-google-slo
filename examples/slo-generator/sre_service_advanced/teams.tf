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
  team1_configs = [
    for cfg_path in fileset(path.module, "/configs/team1/slo_*.yaml") :
    yamldecode(file("${path.module}/${cfg_path}"))
  ]
  team2_configs = [
    for cfg_path in fileset(path.module, "/configs/team2/slo_*.yaml") :
    yamldecode(file("${path.module}/${cfg_path}"))
  ]
}

# Team 1 computes their own SLOs, and sets up an exporter to SRE's BigQuery
# dataset.
module "team1-slos" {
  source  = "terraform-google-modules/slo/google//modules/slo-generator"
  version = "~> 3.0"

  project_id            = var.team1_project_id
  region                = var.region
  config                = local.team1_config
  slo_configs           = local.team1_configs
  slo_generator_image   = var.slo_generator_image
  slo_generator_version = var.slo_generator_version
  secrets = {
    SRE_PROJECT_ID          = var.project_id
    SRE_BIGQUERY_DATASET_ID = google_bigquery_dataset.export-dataset.dataset_id
    PROJECT_ID              = var.team1_project_id
  }
}

# Team 2 manages a GCS bucket with their SLO configs, but wants to use
# SRE-as-a-service.
module "team2-slos" {
  source  = "terraform-google-modules/slo/google//modules/slo-generator"
  version = "~> 3.0"

  project_id     = var.team2_project_id
  region         = var.region
  slo_configs    = local.team2_configs
  service_url    = module.slo-generator.service_url
  create_service = false
}
