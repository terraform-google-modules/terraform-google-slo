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

module "slo_basic" {
  source = "../../../modules/slo-native"
  config = {
    project_id        = var.app_engine_project_id
    service           = data.google_monitoring_app_engine_service.default.service_id
    slo_id            = "gae-latency500ms"
    display_name      = "90% of App Engine default service HTTP response latencies < 500ms over a day"
    goal              = 0.9
    calendar_period   = "DAY"
    type              = "basic_sli"
    method            = "latency"
    latency_threshold = "0.5s"
  }
}

module "slo_request_based" {
  source = "../../../modules/slo-native"
  config = {
    project_id          = var.project_id
    service             = google_monitoring_custom_service.customsrv.service_id
    slo_id              = "gcp-latency400ms"
    display_name        = "90% of Google APIs HTTP response latencies < 400ms over a rolling 30-days period"
    goal                = 0.9
    rolling_period_days = 30
    type                = "request_based_sli"
    method              = "distribution_cut"
    metric_filter       = <<EOF
metric.type="serviceruntime.googleapis.com/api/request_latencies"
resource.type="consumed_api"
resource.label."project_id"="${var.project_id}"
EOF
    range_min           = 0
    range_max           = 400
  }
}

module "slo_windows_based_boolean" {
  source = "../../../modules/slo-native"
  config = {
    project_id      = var.project_id
    slo_id          = "uptime-pass-window"
    service         = google_monitoring_custom_service.customsrv.service_id
    display_name    = "95% of 400s windows 'good' over two weeks. Good window = Uptime check passing."
    goal            = 0.95
    calendar_period = "FORTNIGHT"
    type            = "windows_based_sli"
    method          = "boolean_filter"
    window_period   = "400s"
    metric_filter   = <<EOF
metric.type="monitoring.googleapis.com/uptime_check/check_passed"
resource.type="uptime_url"
EOF
  }
}

module "slo_windows_based_mean_range" {
  source = "../../../modules/slo-native"
  config = {
    project_id          = var.project_id
    slo_id              = "cass-latency5ms-window"
    service             = google_monitoring_custom_service.customsrv.service_id
    display_name        = "90% of 400s windows 'good' over a rolling 20-days period. Good window = Cassandra 95th percentile latency < 5ms."
    goal                = 0.9
    rolling_period_days = 20
    type                = "windows_based_sli"
    method              = "metric_mean_in_range"
    window_period       = "600s"
    metric_filter       = <<EOF
metric.type="agent.googleapis.com/cassandra/client_request/latency/95p"
resource.type="gce_instance"
EOF
    range_max           = 5 # ms
  }
}

module "slo_windows_based_sum_range" {
  source = "../../../modules/slo-native"
  config = {
    project_id          = var.project_id
    slo_id              = "uptime-latency500ms-window"
    service             = google_monitoring_custom_service.customsrv.service_id
    display_name        = "90% of 600s windows are good, over a rolling 20-days period. Good window = Sum of uptime checks request latency < 500ms."
    goal                = 0.9
    rolling_period_days = 20
    type                = "windows_based_sli"
    method              = "metric_sum_in_range"
    window_period       = "600s"
    metric_filter       = <<EOF
metric.type="monitoring.googleapis.com/uptime_check/request_latency"
resource.type="uptime_url"
EOF
    range_min           = 0   # ms
    range_max           = 500 # ms
  }
}

module "slo_windows_based_good_total_ratio_threshold" {
  source = "../../../modules/slo-native"
  config = {
    project_id          = var.project_id
    slo_id              = "gcp-latency500ms-window"
    service             = google_monitoring_custom_service.customsrv.service_id
    display_name        = "90% of 100s windows are good, over a rolling 20-days rolling. Good window = Average Google APIs request latency is <500ms."
    goal                = 0.9
    rolling_period_days = 20
    window_period       = "100s"
    type                = "windows_based_sli"
    method              = "performance_window"
    method_performance  = "distribution_cut"
    metric_filter       = <<EOF
metric.type="serviceruntime.googleapis.com/api/request_latencies"
resource.type="consumed_api"
EOF
    range_min           = 0   # ms
    range_max           = 500 # ms
  }
}
