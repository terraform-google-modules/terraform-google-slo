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
  config = yamldecode(file("${path.module}/configs/config.yaml"))
  slo_configs = [
    for cfg_path in fileset(path.module, "/configs/slo_*.yaml") :
    yamldecode(file("${path.module}/${cfg_path}"))
  ]
}

module "slo-generator" {
  source  = "terraform-google-modules/slo/google//modules/slo-generator"
  version = "~> 3.0"

  project_id            = var.project_id
  region                = var.region
  config                = local.config
  slo_configs           = local.slo_configs
  slo_generator_version = var.slo_generator_version
  slo_generator_image   = var.slo_generator_image
  secrets = {
    PROJECT_ID = var.project_id
  }
}
