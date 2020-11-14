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

resource "google_bigquery_dataset" "main" {
  count                       = var.dataset_create == false ? 0 : length(local.bigquery_configs)
  project                     = local.bigquery_configs[count.index].project_id
  dataset_id                  = local.bigquery_configs[count.index].dataset_id
  delete_contents_on_destroy  = lookup(local.bigquery_configs[count.index], "delete_contents_on_destroy", false)
  location                    = lookup(local.bigquery_configs[count.index], "location", "EU")
  friendly_name               = "SLO Reports"
  description                 = "Table storing SLO reports from SLO reporting pipeline"
  default_table_expiration_ms = local.dataset_expiration
}
