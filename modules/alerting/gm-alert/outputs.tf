output "project_id" {
  description = "Project id"
  value       = var.project_id
}

output "config" {
  description = "SLO Config"
  value       = var.config
}

output "error_budget_policy" {
  description = "Error budget policy config"
  value       = var.error_budget_policy
}

output "slo_alerts" {
  description = "All google monitoring alerts policy for SLO"
  value       = google_monitoring_alert_policy.alert_policy
}

output "no_data_alert" {
  description = "google monitoring alert policy for NO_DATA"
  value       = google_monitoring_alert_policy.alert_policy_no_data
}