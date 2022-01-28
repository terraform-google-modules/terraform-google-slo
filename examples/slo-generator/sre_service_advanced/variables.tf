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
  description = "SRE Project id"
}

variable "schedule" {
  description = "Cron-like Cloud Scheduler schedule"
  default     = "* * * * */1"
}

variable "region" {
  description = "Region"
  default     = "us-east1"
}

variable "labels" {
  description = "Project labels"
  default     = {}
}

variable "secrets" {
  description = "SLO Generator secrets"
  default     = {}
}

variable "pubsub_topic_name" {
  description = "PubSub topic name"
  default     = "slo-export"
}

variable "bigquery_dataset_name" {
  description = "BigQuery dataset to hold SLO reports"
  default     = "slos"
}

variable "team1_project_id" {
  description = "Team 1 project id"
}

variable "team2_project_id" {
  description = "Team 2 project id"
}