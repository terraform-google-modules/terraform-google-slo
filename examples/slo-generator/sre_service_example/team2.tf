/**
 * Copyright 2020 Google LLC
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
  team2_configs = [
    for cfg in fileset(path.module, "/configs/team2/slo_*.yaml") :
    yamldecode(file(cfg))
  ]
  team2_shared_config = yamldecode(file("configs/team2/config.yaml"))
}

# MODEL: Self-managed service
# Team2 deploys their own slo-generator service (shared config is team2/config.yaml), 
# and still want to export to the shared BigQuery dataset to get analytics 
# results by SRE team.
module "team2-slos" {
  source       = "../../../modules/slo-generator"
  service_name = "slo-generator-team2"
  project_id   = var.team2_project_id
  region       = var.region
  config       = local.team2_shared_config
  slo_configs  = local.team2_configs
  secrets = {
    PROJECT_ID = var.team2_project_id
    SRE_PROJECT_ID   = var.project_id
  }
}

output "team2-slos" {
  value = module.team2-slos
}


