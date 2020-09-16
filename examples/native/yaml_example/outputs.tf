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

output "slo-cass-latency5ms-window" {
  value = module.slo-cass-latency5ms-window
}

output "slo-gae-latency500ms" {
  value = module.slo-gae-latency500ms
}

output "slo-gcp-latency400ms" {
  value = module.slo-gcp-latency400ms
}

output "slo-gcp-latency500ms-window" {
  value = module.slo-gcp-latency500ms-window
}

output "slo-uptime-latency500ms" {
  value = module.slo-uptime-latency500ms-window
}

output "slo-uptime-pass" {
  value = module.slo-uptime-pass-window
}
