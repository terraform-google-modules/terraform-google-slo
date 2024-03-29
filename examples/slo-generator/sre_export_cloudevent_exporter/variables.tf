/**
 * Copyright 2022 Google LLC
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

variable "region" {
  description = "Region"
  default     = "us-east1"
}

variable "project_id" {
  description = "SRE Project id"
}

variable "team1_project_id" {
  description = "Team 1 project id"
}

variable "gcr_project_id" {
  description = "Google Container Registry project to fetch slo-generator image from"
  default     = "slo-generator-ci-a2b4"
}

variable "slo_generator_version" {
  description = "Version of slo-generator image"
  default     = "latest"
}
