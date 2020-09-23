variable "project_id" {}

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
