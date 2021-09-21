locals {
  team_projects = [
    var.team1_project_id,
    var.team2_project_id,
  ]
}

resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = "slo-generator"
  display_name = "SLO Generator Service Account"
}

# SA needs to read from GCS buckets containing SLOs in other projects
resource "google_project_iam_member" "object-viewer" {
  count   = length(local.team_projects)
  project = local.team_projects[count.index]
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${local.service_account_email}"
}

# SA needs to read / write from Cloud Ops workspace in other projects
resource "google_project_iam_member" "monitoring-viewer" {
  count   = length(local.team_projects)
  project = local.team_projects[count.index]
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${local.service_account_email}"
}

resource "google_project_iam_member" "monitoring-metric-writer" {
  count   = length(local.team_projects)
  project = local.team_projects[count.index]
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${local.service_account_email}"
}
