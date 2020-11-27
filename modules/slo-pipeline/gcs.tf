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
  exporters_url = "gs://${local.bucket_name}/${google_storage_bucket_object.exporters.output_name}"
}

resource "google_storage_bucket" "slos" {
  project       = var.project_id
  name          = local.bucket_name
  location      = var.storage_bucket_location
  force_destroy = true
  storage_class = var.storage_bucket_class
  labels        = var.labels
}

resource "google_storage_bucket_object" "exporters" {
  name    = "config/exporters.json"
  content = jsonencode(var.exporters)
  bucket  = google_storage_bucket.slos.name
}
