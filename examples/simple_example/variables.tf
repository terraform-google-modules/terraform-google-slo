/**
 * Copyright 2018 Google LLC
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

variable "org_id" {
  description = "Organization id"
}

variable "folder_id" {
  description = "Folder id"
}

variable "billing_account" {
  description = "Billing account id"
}

variable "bucket_name" {
  description = "GCS bucket name to create"
}

variable "project_name" {
  description = "Project name"
  default     = "slo-pipeline"
}

variable "stackdriver_host_project_id" {
  description = "Stackdriver host project id"
}

variable "region" {
  description = "Region"
}

variable "labels" {
  description = "Project labels"
  default     = {}
}

variable "credentials_path" {
  description = "Path to gcloud credentials"
}
