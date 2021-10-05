locals {
  roles = concat([
    "roles/monitoring.viewer",
    "roles/monitoring.metricWriter",
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor",
    "roles/storage.objectViewer",
    google_project_iam_custom_role.bucket-reader.id
  ], var.additional_project_roles)
}

resource "google_project_iam_custom_role" "bucket-reader" {
  project     = var.project_id
  role_id     = "BucketAccessor"
  title       = "Bucket accessor"
  description = "Bucket accessor"
  permissions = ["storage.buckets.get"]
}

resource "google_project_iam_member" "sa-roles" {
  count   = var.create_iam_roles ? length(local.roles) : 0
  project = var.project_id
  role    = local.roles[count.index]
  member  = "serviceAccount:${local.service_account_email}"
}
