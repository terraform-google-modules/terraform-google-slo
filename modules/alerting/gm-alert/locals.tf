locals {
  steps              = { for step in var.error_budget_policy : step["error_budget_policy_step_name"] => step }
  alert_policy_name  = upper("${var.config.slo_name}_${var.config.service_name}_${var.config.feature_name}")
  filter_common_part = "metric.type=\"custom.googleapis.com/error_budget_burn_rate\" AND resource.type=\"global\" AND resource.label.\"project_id\"=\"${var.project_id}\" AND metric.label.\"slo_name\"=\"${var.config.slo_name}\" AND metric.label.\"service_name\"=\"${var.config.service_name}\" AND metric.label.\"feature_name\"=\"${var.config.feature_name}\""
}
