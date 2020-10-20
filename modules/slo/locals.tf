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
  # Template rendering (JSON / YAML)
  is_yaml_config    = length(regexall(".*yaml", var.config_path)) > 0
  is_yaml_exporters = length(regexall(".*yaml", var.exporters_path)) > 0
  is_yaml_ebp       = length(regexall(".*yaml", var.error_budget_policy_path)) > 0

  # SLO config
  config_tpl = templatefile(var.config_path, var.config_vars)
  config_map = local.is_yaml_config ? yamldecode(local.config_tpl) : jsondecode(local.config_tpl)

  # EBP config
  error_budget_policy_tpl = file(var.error_budget_policy_path)
  error_budget_policy     = local.is_yaml_ebp ? yamldecode(local.error_budget_policy_tpl) : jsondecode(local.error_budget_policy_tpl)

  # Exporters configs
  exporters_tpl  = templatefile(var.exporters_path, var.exporters_vars)
  exporters_list = local.is_yaml_exporters ? yamldecode(local.exporters_tpl) : jsondecode(local.exporters_tpl)
  exporters      = concat(tolist(lookup(local.config_map, "exporters", [])), local.exporters_list)

  # Merge exporter in file with exporters in config
  config = merge(local.config_map, { exporters = local.exporters })
}
