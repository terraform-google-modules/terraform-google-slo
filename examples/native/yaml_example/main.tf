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

module "slo-cass-latency5ms-window" {
  source = "../../../modules/slo-native"
  config = local.slo_config_map["cass-latency5ms-window"]
}

module "slo-gae-latency500ms" {
  source = "../../../modules/slo-native"
  config = local.slo_config_map["gae-latency500ms"]
}

module "slo-gcp-latency400ms" {
  source = "../../../modules/slo-native"
  config = local.slo_config_map["gcp-latency400ms"]
}

module "slo-gcp-latency500ms-window" {
  source = "../../../modules/slo-native"
  config = local.slo_config_map["gcp-latency500ms-window"]
}

module "slo-uptime-latency500ms-window" {
  source = "../../../modules/slo-native"
  config = local.slo_config_map["uptime-latency500ms-window"]
}

module "slo-uptime-pass-window" {
  source = "../../../modules/slo-native"
  config = local.slo_config_map["uptime-pass-window"]
}
