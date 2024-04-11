/**
 * Copyright 2021-2024 Google LLC
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
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "config" {
  description = "slo-generator shared config"
  type        = any
  default     = {}
}

variable "slo_configs" {
  description = "slo-generator SLO configs"
  type        = list(any)
  default     = []
}

variable "gcr_project_id" {
  description = "slo-generator image project id"
  type        = string
  default     = "slo-generator-ci-a2b4"
}

variable "slo_generator_version" {
  description = "slo-generator container image version"
  type        = string
  default     = "latest"
}

variable "service_name" {
  description = "Cloud Run service name"
  type        = string
  default     = "slo-generator"
}

variable "service_url" {
  description = "Cloud Run service URL. Will be created if empty."
  type        = string
  default     = ""
}

variable "annotations" {
  description = "Cloud Run service annotations (see https://cloud.google.com/run/docs/reference/rest/v1/RevisionTemplate)"
  type        = map(any)
  default     = {}
}

variable "ingress" {
  description = "Cloud Run service ingress settings, between 'all', 'internal', 'internal-and-cloud-load-balancing', see https://cloud.google.com/sdk/gcloud/reference/run/deploy#--ingress"
  type        = string
  default     = "all"
}

variable "requests" {
  description = "Cloud Run service resources.requests configuration"
  type        = map(any)
  default     = {}
}

variable "limits" {
  description = "Cloud Run service resources.limits configuration"
  type        = map(any)
  default = {
    cpu    = "1000m"
    memory = "512Mi"
  }
}

variable "concurrency" {
  description = "Cloud Run service concurrency (number of threads per container instance)"
  type        = number
  default     = 80
}

variable "bucket_name" {
  description = "slo-generator GCS bucket name"
  type        = string
  default     = ""
}

variable "env" {
  description = "Cloud Run service env variables"
  type        = map(any)
  default     = {}
}

variable "secrets" {
  description = "Cloud Run service secrets"
  type        = map(any)
  default     = {}
}

variable "service_account_email" {
  description = "Cloud Run service account. Defaults to compute service account."
  type        = string
  default     = ""
}

variable "signature_type" {
  description = "Functions Framework signature type, between 'http' and 'cloudevent'. In 'cloudevent' mode the POST request data needs to be warpped in a Cloud Event."
  type        = string
  default     = "http"
}

variable "target" {
  description = "Functions Framework target, between 'run_compute' and 'run_export'. If `run_compute`, the API accepts SLO configs as input, if 'run_export' the API accepts SLO reports as input."
  type        = string
  default     = "run_compute" # "run_export" is possible
}

variable "schedule" {
  description = "Cloud Scheduler schedule"
  type        = string
  default     = "* * * * *"
}

variable "create_cloud_schedulers" {
  description = "Whether to create Cloud Schedulers for each SLO or not"
  type        = bool
  default     = true
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

variable "additional_project_roles" {
  description = "Additional roles to grant to service account in project"
  type        = list(string)
  default     = []
}

variable "create_iam_roles" {
  description = "Whether to create IAM roles"
  type        = bool
  default     = true
}

variable "create_service" {
  description = "Create service"
  type        = bool
  default     = true
}
