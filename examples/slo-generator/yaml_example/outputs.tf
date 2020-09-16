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

# Note: As most of the submodules outputs are needed: we are just forwarding all
# submodules outputs here. Please refer to the submodules outputs.tf file to
# have a breakdown.

output "slo_pipeline" {
  description = "SLO pipeline outputs"
  value       = module.slo-pipeline
}

output "slo-generator-bq-latency" {
  value = module.slo-generator-bq-latency
}

output "slo-generator-gcf-errors" {
  value = module.slo-generator-gcf-errors
}

output "slo-generator-pubsub-ack" {
  value = module.slo-generator-pubsub-ack
}
