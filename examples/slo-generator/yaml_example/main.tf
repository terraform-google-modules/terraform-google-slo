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

provider "google" {
  version = "~> 3.19"
}

provider "google-beta" {
  version = "~> 3.19"
}

locals {
  config    = yamldecode(file("templates/config.yaml"))
  exporters = yamldecode(templatefile("templates/exporters.yaml", var.secrets))
  slo_configs = [
    for file in fileset(path.module, "/templates/slo_*.yaml") :
    yamldecode(templatefile(file, var.secrets), {
      exporters = ["cloud_monitoring"]
    })
  ]
}

module "slo-service-compute" {
  source      = "../../modules/slo-generator"
  project_id  = var.project_id
  region      = var.region
  bucket_name = var.bucket_name
  config      = local.config
  slo_configs = local.slo_configs
  exporters   = local.exporters.slo
}
