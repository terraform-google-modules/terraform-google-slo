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

variable "project_id" {
  description = "SLO project id"
}

variable "region" {
  description = "Region to deploy the Cloud Function in"
  default     = "us-east1"
}

variable "schedule" {
  description = "Cron-like schedule for Cloud Scheduler"
  default     = "* * * * */1"
}

variable "labels" {
  description = "Labels to apply to all resources created"
  default     = {}
}

variable "config" {
  description = "SLO Configuration"
  type = object({
    slo_name        = string
    slo_target      = number
    slo_description = string
    service_name    = string
    feature_name    = string
    exporters = list(object({
      class      = string
      project_id = string
      topic_name = string
    }))
    backend = object({
      class       = string
      project_id  = string
      method      = string
      measurement = map(string)
    })
  })
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
  default = [
    {
      error_budget_policy_step_name  = "a.Last 1 hour",
      measurement_window_seconds     = 3600,
      alerting_burn_rate_threshold   = 9,
      urgent_notification            = true,
      overburned_consequence_message = "Page the SRE team to defend the SLO",
      achieved_consequence_message   = "Last hour on track"
    },
    {
      error_budget_policy_step_name  = "b.Last 12 hours",
      measurement_window_seconds     = 43200,
      alerting_burn_rate_threshold   = 3,
      urgent_notification            = true,
      overburned_consequence_message = "Page the SRE team to defend the SLO",
      achieved_consequence_message   = "Last 12 hours on track"
    },
    {
      error_budget_policy_step_name  = "c.Last 7 days",
      measurement_window_seconds     = 604800,
      alerting_burn_rate_threshold   = 1.5,
      urgent_notification            = false,
      overburned_consequence_message = "Dev team dedicates two Engineers to the action items of the post-mortem",
      achieved_consequence_message   = "Last week on track"
    },
    {
      error_budget_policy_step_name  = "d.Last 28 days",
      measurement_window_seconds     = 2419200,
      alerting_burn_rate_threshold   = 1,
      urgent_notification            = false,
      overburned_consequence_message = "Freeze release, unless related to reliability or security",
      achieved_consequence_message   = "Unfreeze release, per the agreed roll-out policy"
    }
  ]
}
