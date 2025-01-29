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
  project_id           = var.config["project_id"]
  service              = var.config["service"]
  slo_id               = var.config["slo_id"]
  display_name         = var.config["display_name"]
  goal                 = var.config["goal"]
  type                 = var.config["type"]
  calendar_period      = lookup(var.config, "calendar_period", null)
  rolling_period_days  = lookup(var.config, "rolling_period_days", null)
  method               = lookup(var.config, "method", null)
  method_performance   = lookup(var.config, "method_performance", null)
  metric_filter        = lookup(var.config, "metric_filter", null)
  good_service_filter  = lookup(var.config, "good_service_filter", null)
  bad_service_filter   = lookup(var.config, "bad_service_filter", null)
  total_service_filter = lookup(var.config, "total_service_filter", null)
  range_min            = lookup(var.config, "range_min", null)
  range_max            = lookup(var.config, "range_max", null)
  latency_threshold    = lookup(var.config, "latency_threshold", null)
  threshold            = lookup(var.config, "threshold", null)
  window_period        = lookup(var.config, "window_period", null)
  api_method           = lookup(var.config, "api_method", null)
  api_location         = lookup(var.config, "api_location", null)
  api_version          = lookup(var.config, "api_version", null)
}
