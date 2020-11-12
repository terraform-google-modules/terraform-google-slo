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
  description = "Project id to create SLO infrastructure"
}

variable "exporters" {
  description = "SLO export destinations config"
  type        = any
}

variable "pubsub_topic_name" {
  description = "Pub/Sub topic name"
  default     = "slo-export-topic"
}

variable "function_bucket_name" {
  description = "Name of the bucket to create to store the Cloud Function code"
  default     = "slo-pipeline"
}

variable "function_name" {
  description = "Cloud Function name"
  default     = "slo-pipeline"
}

variable "function_memory" {
  description = "Memory in MB for the Cloud Function (increases with no. of SLOs)"
  default     = 128
}

variable "function_timeout" {
  description = "Timeout (in seconds)"
  default     = "90"
}

variable "function_environment_variables" {
  description = "Cloud Function environment variables"
  default     = {}
}

variable "vpc_connector" {
  description = "VPC Connector. The format of this field is projects/*/locations/*/connectors/*."
  default     = null
}

variable "vpc_connector_egress_settings" {
  description = "VPC Connector Egress Settings. Allowed values are ALL_TRAFFIC and PRIVATE_RANGES_ONLY."
  default     = null
}

variable "region" {
  description = "Region for the App Engine app"
  default     = "us-east1"
}

variable "storage_bucket_location" {
  description = "The GCS location"
  default     = "US"
}

variable "storage_bucket_class" {
  description = "The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE"
  default     = "STANDARD"
}

variable "service_account_name" {
  description = "Name of the service account to create"
  default     = "slo-pipeline"
}

variable "use_custom_service_account" {
  type        = bool
  description = "Use a custom service account (pass service_account_email if true)"
  default     = false
}

variable "service_account_email" {
  description = "Service account email (optional)"
  default     = ""
}

variable "grant_iam_roles" {
  description = "Grant IAM roles to created service accounts"
  default     = true
}

variable "function_source_directory" {
  type        = string
  description = "The contents of this directory will be archived and used as the function source. (defaults to standard SLO generator code)"
  default     = ""
}

variable "dataset_default_table_expiration_ms" {
  type        = number
  description = "The default lifetime of the slo table in the dataset, in milliseconds. Default is never (Recommended)"
  default     = -1 # no expiration
}

variable "dataset_create" {
  type        = bool
  description = "Whether to create the BigQuery dataset"
  default     = true
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

variable "labels" {
  description = "Labels to apply to all resources created"
  default     = {}
}
