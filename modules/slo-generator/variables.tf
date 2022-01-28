/**
 * Copyright 2021 Google LLC
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
  description = "Project id"
}

variable "gcr_project_id" {
  description = "GCR Project id"
  default     = "slo-generator-ci-a2b4"
}

variable "region" {
  description = "GCP region"
  default     = "europe-west1"
}

variable "config" {
  description = "slo-generator shared config"
}

variable "slo_generator_version" {
  description = "slo-generator version to deploy"
  default     = "latest"
}

variable "service_name" {
  description = "slo-generator service name"
  default     = "slo-generator"
}

variable "service_url" {
  description = "slo-generator service URL. Will be created if empty."
  default     = ""
}

variable "exporters" {
  description = "slo-generator shared exporters"
  type        = map(any)
  default     = {}
}

variable "bucket_name" {
  description = "slo-generator GCS bucket name"
  default     = ""
}

variable "secrets" {
  description = "slo-generator secrets"
  default     = {}
}

variable "slo_configs" {
  description = "slo-generator SLO configs"
  default     = []
}

variable "service_account_email" {
  description = "Cloud Run service account. Defaults to compute service account."
  default     = ""
}

variable "mode" {
  description = "SLO Generator API mode"
  default     = "compute" # "export" is possible
}

variable "schedule" {
  description = "Cloud Scheduler schedule"
  default     = "* * * * *"
}

variable "create_cloud_schedulers" {
  description = "Whether to create Cloud Schedulers for each SLO or not"
  default     = true
}

variable "pubsub_topic_name" {
  description = "Input PubSub topic"
  default     = "export"
}

variable "labels" {
  description = "Resource labels"
  type        = map(any)
  default     = {}
}

variable "authorized_members" {
  description = "List of emails that are allowed to call the service"
  type        = list(string)
  default     = []
}

variable "annotations" {
  description = "Cloud Run service annotations (see https://cloud.google.com/run/docs/reference/rest/v1/RevisionTemplate)"
  default = {
    "autoscaling.knative.dev/minScale" = "1"
  }
}

variable "additional_project_roles" {
  description = "Additional roles to grant to service account in project"
  default     = []
}

variable "create_iam_roles" {
  description = "Whether to create IAM roles"
  default     = true
}

variable "create_service" {
  description = "Create service"
  default     = true
}