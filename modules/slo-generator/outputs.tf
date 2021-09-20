output "storage_objects" {
  value = google_storage_bucket_object.slos
}

output "scheduler_jobs" {
  value = google_cloud_scheduler_job.scheduler
}
