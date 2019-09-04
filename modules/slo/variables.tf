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

variable "name" {
  description = "SLO name"
}

variable "description" {
  description = "SLO description"
}

variable "service_name" {
  description = "Name of monitored service"
}

variable "feature_name" {
  description = "Name of monitored feature"
}

variable "target" {
  description = "Target for this SLO"
}

variable "backend_class" {
  description = "SLO backend class"
  default     = "Stackdriver"
}

variable "backend_project_id" {
  description = "Project id for the metrics backend"
}

variable "backend_method" {
  description = "SLO computation method"
}

variable "backend_measurement" {
  description = "SLO measurement config"
  type = map(string)
}

variable "region" {
  description = "Region"
}

variable "schedule" {
  description = "Cron-like schedule"
  default     = "* * * * */1"
}

variable "pubsub_project_id" {
  description = "Pub/Sub project id to send results to"
}

variable "pubsub_topic_name" {
  description = "Pub/Sub topic name to send results to"
}

variable "labels" {
  description = "Labels to apply to all resources created"
}
