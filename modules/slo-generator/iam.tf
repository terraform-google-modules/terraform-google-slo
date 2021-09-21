local {
  roles = concat([
    "roles/storage.objectReader",
    "roles/monitoring.viewer",
    "roles/monitoring.metricWriter",
    "roles/run.invoker"
  ], var.additional_project_roles)
}

resource "google_project_iam_member" "sa-roles" {
  count   = var.create_iam_roles ? length(local.roles) : 0
  project = var.project_id
  role    = local.roles[count.index]
  member  = "serviceAccount:${local.service_account_email}"
}
