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
  default     = "1.3.0"
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
  description = "SLO generator GCS bucket to store configs. Create one if empty."
  default     = ""
}

variable "vpc_connector" {
  description = "VPC Connector URI"
  default     = null
}

variable "vpc_connector_egress_settings" {
  description = "VPC Connector Egress Settings"
  default     = null
}

variable "environment_variables" {
  description = "SLO generator env variables"
  default     = {}
}

variable "config_path" {
  description = "Path to SLO config"
  type        = string
}

variable "config_vars" {
  description = "Variables to dynamically replace in SLO config"
  type        = map
}

variable "exporters_path" {
  description = "Path to SLO exporters"
  type        = string
}

variable "exporters_vars" {
  description = "variables to dynamically replace in SLO exporters config"
  type        = map
}

variable "exporters_key" {
  description = "Key in config to extract exporters from"
  default     = null
}

variable "error_budget_policy_path" {
  description = "Error budget policy path"
  type        = string
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

variable "function_timeout_s" {
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
  description = "A set of key/value environment variable pairs to assign to the function."
}
