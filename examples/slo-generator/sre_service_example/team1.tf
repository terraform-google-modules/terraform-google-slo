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
  team1_configs = [
    for cfg in fileset(path.module, "/configs/team1/slo_*.yaml") :
    yamldecode(file(cfg))
  ]
}

# MODEL: Self-managed configs
# Team1 deploys their SLOs configs to a bucket located in their own project, and
# want to use the shared slo-generator service managed by SRE team.
module "team1-slos" {
  source         = "../../../modules/slo-generator"
  project_id     = var.team1_project_id
  region         = var.region
  slo_configs    = local.team1_configs
  service_url    = module.slo-generator.service_url
  create_service = false
}

output "team1-slos" {
  value = module.team1-slos
}
