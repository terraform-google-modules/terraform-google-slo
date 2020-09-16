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
data "google_monitoring_app_engine_service" "default" {
  project   = var.app_engine_project_id
  module_id = "default"
}

resource "google_monitoring_custom_service" "customsrv" {
  project      = var.project_id
  service_id   = "custom-srv-request-slos"
  display_name = "My Custom Service"
}
