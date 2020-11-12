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

variable "slo_generator_version" {
  description = "SLO generator library version"
  default     = "1.3.2"
}

variable "extra_files" {
  description = "Extra files to add to the Google Cloud Function code"
  default     = []
  type = list(object({
    content  = string,
    filename = string
  }))
}

variable "config_bucket" {
  description = "SLO generator GCS bucket to store configs and GCF code."
  default     = "" # create one
}

variable "config_bucket_region" {
  description = "Config bucket region"
  default     = "EU"
}

variable "vpc_connector" {
  description = "VPC Connector. The format of this field is projects/*/locations/*/connectors/*."
  default     = null
}

variable "vpc_connector_egress_settings" {
  description = "VPC Connector Egress Settings. Allowed values are ALL_TRAFFIC and PRIVATE_RANGES_ONLY."
  default     = null
}

variable "config" {
  description = "SLO Configuration"
  type = object({
    slo_name        = string
    slo_target      = number
    slo_description = string
    service_name    = string
    feature_name    = string
    backend         = any
    exporters       = any
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

variable "use_custom_service_account" {
  type        = bool
  description = "Use a custom service account (pass service_account_email if true)"
  default     = false
}

variable "service_account_email" {
  type        = string
  description = "Service account email (optional)"
  default     = ""
}

variable "service_account_name" {
  type        = string
  description = "Service account name (in case the generated one is too long)"
  default     = ""
}

variable "grant_iam_roles" {
  description = "Grant IAM roles to created service accounts"
  default     = true
}

variable "message_data" {
  type        = string
  description = "The data to send in the topic message."
  default     = "dGVzdA=="
}

variable "time_zone" {
  type        = string
  description = "The timezone to use in scheduler"
  default     = "Etc/UTC"
}

variable "bucket_force_destroy" {
  type        = string
  default     = "true"
  description = "When deleting the GCS bucket containing the cloud function, delete all objects in the bucket first."
}

variable "function_memory" {
  description = "Memory in MB for the Cloud Function (increases with no. of SLOs)"
  default     = 128
}

variable "function_timeout" {
  type        = number
  default     = 60
  description = "The amount of time in seconds allotted for the execution of the function."
}

variable "function_source_archive_bucket_labels" {
  type        = map(string)
  default     = {}
  description = "A set of key/value label pairs to assign to the function source archive bucket."
}

variable "function_source_directory" {
  type        = string
  description = "The contents of this directory will be archived and used as the function source. (defaults to standard SLO generator code)"
  default     = ""
}

variable "function_labels" {
  type        = map(string)
  default     = {}
  description = "A set of key/value label pairs to assign to the function."
}

variable "function_environment_variables" {
  type        = map(string)
  default     = {}
  description = "Cloud Function environment variables."
}
