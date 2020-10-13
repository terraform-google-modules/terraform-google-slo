/**
 * Copyright 2020 Google LLC
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

locals {
  slo_bucket_name         = var.config_bucket == "" ? google_storage_bucket.slos.name : var.config_bucket
  slo_config_url          = "gs://${local.slo_bucket_name}/${google_storage_bucket_object.slo_config.output_name}"
  error_budget_policy_url = "gs://${local.slo_bucket_name}/${google_storage_bucket_object.error_budget_policy.output_name}"
}

resource "google_storage_bucket" "slos" {
  project  = var.project_id
  name     = "${local.full_name}-conf"
  location = "EU"
}

resource "google_storage_bucket_object" "slo_config" {
  name    = "slos/${local.full_name}/slo_config.json"
  content = jsonencode(var.config)
  bucket  = local.slo_bucket_name
}

resource "google_storage_bucket_object" "error_budget_policy" {
  name    = "slos/${local.full_name}/error_budget_policy.json"
  content = jsonencode(var.error_budget_policy)
  bucket  = local.slo_bucket_name
}
