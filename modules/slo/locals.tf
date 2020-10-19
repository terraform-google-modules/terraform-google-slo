locals {
  # Template rendering (JSON / YAML)
  is_yaml_config            = length(regexall(".*yaml", var.config_path)) > 0
  is_yaml_exporters         = length(regexall(".*yaml", var.exporters_path)) > 0
  is_yaml_ebp               = length(regexall(".*yaml", var.error_budget_policy_path)) > 0
  
  # SLO config
  config_tpl                = templatefile(var.config_path, var.config_vars)
  config                    = local.is_yaml_config ? yamldecode(local.config_tpl) : jsondecode(local.config_tpl)

  # EBP config
  error_budget_policy_tpl   = file(var.error_budget_policy_path)
  error_budget_policy       = local.is_yaml_ebp ? yamldecode(local.error_budget_policy_tpl) : jsondecode(local.error_budget_policy_tpl)

  # Exporters configs
  exporters_tpl             = templatefile(var.exporters_path, var.exporters_vars)
  exporters_map             = local.is_yaml_exporters ? yamldecode(local.exporters_tpl) : jsondecode(local.exporters_tpl)
  exporters                 = local.exporters_map
}
