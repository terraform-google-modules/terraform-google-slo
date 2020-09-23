locals {
  steps = { for step in var.error_budget_policy : step["error_budget_policy_step_name"] => step }
}

resource "google_monitoring_alert_policy" "alert_policy" {
  for_each     = local.steps
  project      = var.project_id
  display_name = each.value["error_budget_policy_step_name"]
  combiner     = "OR"
  conditions {
    display_name = each.value["error_budget_policy_step_name"]
    condition_threshold {
      filter          = "metric.type=\"custom.googleapis.com/error_budget_burn_rate\" AND resource.type=\"global\" AND metric.labels.error_budget_policy_step_name=\"${each.value["error_budget_policy_step_name"]}\""
      duration        = "60s"
      comparison      = lookup(each.value, "comparison", "COMPARISON_GT")
      threshold_value = each.value["alerting_burn_rate_threshold"]
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
}
