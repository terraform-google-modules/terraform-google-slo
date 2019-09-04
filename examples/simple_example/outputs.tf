/**
 * Copyright 2018 Google LLC
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
output "slo-pipeline" {
  description = "SLO pipeline outputs"
  value = {
    project_id                  = module.slo-pipeline.project_id
    config                      = module.slo-pipeline.config
    function_name               = module.slo-pipeline.function_name
    function_bucket_name        = module.slo-pipeline.function_bucket_name
    function_bucket_object_name = module.slo-pipeline.function_bucket_object_name
    pubsub_topic_name           = module.slo-pipeline.pubsub_topic_name
    bigquery_dataset_self_link  = module.slo-pipeline.bigquery_dataset_self_link
  }
}

output "slo" {
  description = "SLO outputs"
  value = {
    project_id = module.slo.project_id
    service_account_email = module.slo.service_account_email
    config = module.slo.config
    scheduler_job_name = module.slo.scheduler_job_name
  }
}
