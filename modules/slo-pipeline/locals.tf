/**
 * Copyright 2019 Google LLC
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
  exporters_tpl    = templatefile(var.exporters_path, var.exporters_vars)
  exporters_map    = var.exporters_path.contains(".yaml") ? yamldecode(local.exporters_tpl) : jsondecode(local.exporters_tpl)
  exporters        = var.exporters_key != null ? exporters_map.key : exporters_map
  bigquery_configs = [for e in local.exporters : e if lower(e.class) == "bigquery"]
  sd_configs       = [for e in local.exporters : e if lower(e.class) == "stackdriver"]
}
