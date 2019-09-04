/**
 * Copyright 2019 Google LLC
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

output "project_id" {
  value       = var.project_id
  description = "Project id"
}

output "exporters" {
  description = "Rendered exporters configuration for `slo-exporter`"
  value       = data.template_file.exporters.rendered
}

output "function_name" {
  description = "Cloud Function name"
  value       = google_cloudfunctions_function.function.name
}

output "function_bucket_name" {
  description = "Cloud Function bucket name"
  value       = google_storage_bucket.bucket.name
}

output "function_bucket_object_name" {
  description = "Cloud Function code GCS object name"
  value       = google_storage_bucket_object.main.name
}

output "pubsub_topic_name" {
  description = "PubSub topic between Cloud Scheduler and Cloud Function"
  value       = google_pubsub_topic.stream.name
}

output "bigquery_dataset_self_link" {
  description = "BigQuery dataset self link"
  value       = google_bigquery_dataset.main.self_link
}
