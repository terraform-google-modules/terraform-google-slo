variable "project_id" {
  description = "Project id"
  type        = string
}

variable "error_budget_policy" {
  description = "Error budget policy config"
  type = list(object({
    error_budget_policy_step_name  = string
    measurement_window_seconds     = number
    alerting_burn_rate_threshold   = number
    urgent_notification            = bool
    overburned_consequence_message = string
    achieved_consequence_message   = string
  }))
}

variable "config" {
  description = "SLO Configuration"
  type = object({
    slo_name        = string
    slo_target      = number
    slo_description = string
    service_name    = string
    feature_name    = string
    metadata        = map(string)
    backend         = any
    exporters       = any
  })
}

variable "urgent_nc" {
  description = "urgent notification channel for alerting burn rate is gt threshold"
  type        = list(string)
  default     = null
}

variable "non_urgent_nc" {
  description = "non urgent notification channel for alerting burn rate is gt threshold"
  type        = list(string)
  default     = null
}

variable "alert_enabled" {
  description = "Enable SLI alerts"
  type        = bool
  default     = true
}

variable "no_data_alert_enabled" {
  description = "Enable NO_DATA alerts"
  type        = bool
  default     = true
}

variable "no_data_threshold_duration_time" {
  description = "The amount of time that no data are compute by SLO-Generator to be considered failing. Currently, only values that are a multiple of a minute--e.g. 60s, 120s, or 300s --are supported."
  type        = string
  default     = "600s"
}