resource "google_monitoring_alert_policy" "alert_policy" {
  for_each     = local.steps
  project      = var.project_id
  enabled      = var.alert_enabled
  display_name = upper("${local.alert_policy_name}_${each.value["error_budget_policy_step_name"]}")
  combiner     = "OR"
  conditions {
    display_name = "${local.alert_policy_name} - Burning error budget ${each.value["alerting_burn_rate_threshold"]} times too fast over the last ${each.value["error_budget_policy_step_name"]}"
    condition_threshold {
      filter          = "${local.filter_common_part} AND metric.label.\"error_budget_policy_step_name\"=\"${each.value["error_budget_policy_step_name"]}\""
      duration        = "120s"
      comparison      = "COMPARISON_GT"
      threshold_value = each.value["alerting_burn_rate_threshold"]
      aggregations {
        alignment_period     = "60s"
        cross_series_reducer = "REDUCE_MAX"
        per_series_aligner   = "ALIGN_MAX"
        group_by_fields      = ["metric.labels.service_name", "metric.labels.feature_name", "metric.labels.slo_name"]
      }
    }
  }
  documentation {
    content = each.value["overburned_consequence_message"]
  }
  notification_channels = each.value["urgent_notification"] ? var.urgent_notification_channel != null ? var.urgent_notification_channel : null : var.non_urgent_notification_channel != null ? var.non_urgent_notification_channel : null
}

resource "google_monitoring_alert_policy" "alert_policy_no_data" {
  display_name = "${local.alert_policy_name}_NO_DATA"
  project      = var.project_id
  enabled      = var.no_data_alert_enabled
  combiner     = "OR"
  conditions {
    display_name = "No data seen over the last 10 min for ${local.alert_policy_name}"
    condition_absent {
      filter   = "${local.filter_common_part}"
      duration = var.no_data_threshold_duration_time
      aggregations {
        alignment_period     = "60s"
        cross_series_reducer = "REDUCE_MAX"
        per_series_aligner   = "ALIGN_MAX"
        group_by_fields      = ["metric.labels.service_name", "metric.labels.feature_name", "metric.labels.slo_name"]
      }
    }
  }
  documentation {
    content = "Check for the Cloud Functions executions"
  }
  notification_channels = var.non_urgent_notification_channel != null ? var.non_urgent_notification_channel : null
}