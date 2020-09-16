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
  slo_configs = [
    for file in fileset(path.module, "/templates/*.yaml") :
    yamldecode(templatefile(file,
      {
        project_id            = var.project_id,
        app_engine_service_id = data.google_monitoring_app_engine_service.default.service_id,
        service_id            = google_monitoring_custom_service.customsrv.service_id,
    }))
  ]
  slo_config_map = { for config in local.slo_configs : config.slo_id => config }
}

module "slos" {
  for_each = local.slo_config_map
  source   = "../../../modules/slo-native"
  config   = each.value
}
