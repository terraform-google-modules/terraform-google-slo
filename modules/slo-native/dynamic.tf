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
resource "google_monitoring_slo" "slo" {
  project             = local.project_id
  service             = local.service
  slo_id              = local.slo_id
  display_name        = local.display_name
  goal                = local.goal
  calendar_period     = local.calendar_period
  rolling_period_days = local.rolling_period_days

  # Basic SLI definition (GKE, GAE, Cloud Endpoint)
  dynamic "basic_sli" {
    for_each = local.type == "basic_sli" ? ["yes"] : []
    content {
      dynamic "latency" {
        for_each = local.latency_threshold != null ? ["yes"] : []
        content {
          threshold = local.latency_threshold
        }
      }
      dynamic "availability" {
        for_each = local.latency_threshold == null ? ["yes"] : []
        content {
          enabled = true
        }
      }
    }
  }

  # Request-based SLI definition
  dynamic "request_based_sli" {
    for_each = local.type == "request_based_sli" ? ["yes"] : []
    content {

      # Distribution metrics
      dynamic "distribution_cut" {
        for_each = local.method == "distribution_cut" ? ["yes"] : []
        content {
          distribution_filter = local.metric_filter # DISTRIBUTION metric type
          range {
            min = local.range_min
            max = local.range_max
          }
        }
      }

      # Good / bad or good / total ratio
      dynamic "good_total_ratio" {
        for_each = local.method == "good_total_ratio" ? ["yes"] : []
        content {
          good_service_filter  = local.good_service_filter
          bad_service_filter   = local.bad_service_filter
          total_service_filter = local.total_service_filter
        }
      }
    }
  }

  # Windows-based SLI definition
  dynamic "windows_based_sli" {
    for_each = local.type == "windows_based_sli" ? ["yes"] : []
    content {
      window_period = local.window_period

      # Good / bad boolean ratio
      good_bad_metric_filter = local.method == "boolean_filter" ? local.metric_filter : null # BOOL metric type

      # Good / total ratio threshold based on Window performance
      dynamic "good_total_ratio_threshold" {
        for_each = local.method == "performance_window" ? ["yes"] : []
        content {
          threshold = local.threshold

          # Performance window
          dynamic "performance" {
            for_each = local.method_performance == "good_total_ratio" || local.method_performance == "distribution_cut" ? ["yes"] : []
            content {
              dynamic "good_total_ratio" {
                for_each = local.method_performance == "good_total_ratio" ? ["yes"] : []
                content {
                  good_service_filter  = local.good_service_filter
                  bad_service_filter   = local.bad_service_filter
                  total_service_filter = local.total_service_filter
                }
              }
              dynamic "distribution_cut" {
                for_each = local.method_performance == "distribution_cut" ? ["yes"] : []
                content {
                  distribution_filter = local.metric_filter
                  range {
                    min = local.range_min
                    max = local.range_max
                  }
                }
              }
            }
          }

          # Basic SLI performance window
          dynamic "basic_sli_performance" {
            for_each = local.method_performance == "basic_sli_performance" ? ["yes"] : []
            content {
              method   = local.api_method
              location = local.api_location
              version  = local.api_version
              latency {
                threshold = local.latency_threshold
              }
            }
          }
        }
      }

      # Metric mean in range
      dynamic "metric_mean_in_range" {
        for_each = local.method == "metric_mean_in_range" ? ["yes"] : []
        content {
          time_series = local.metric_filter
          range {
            min = local.range_min
            max = local.range_max
          }
        }
      }

      # Metric sum in range
      dynamic "metric_sum_in_range" {
        for_each = local.method == "metric_sum_in_range" ? ["yes"] : []
        content {
          time_series = local.metric_filter
          range {
            min = local.range_min
            max = local.range_max
          }
        }
      }
    }
  }
}
