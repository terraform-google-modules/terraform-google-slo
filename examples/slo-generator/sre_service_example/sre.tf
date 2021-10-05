locals {
  projects = [
    var.project_id,
    var.team1_project_id,
    var.team2_project_id,
  ]
  service_account_email = google_service_account.service_account.email
  sre_config = yamldecode(file("configs/sre/config.yaml"))
  sre_slo_configs = [
    for cfg in fileset(path.module, "/configs/team1/slo_*.yaml") :
    yamldecode(file(cfg))
  ]
}

# SLOs as-a-service, run by SRE team. 
# This service can be used by the various teams to compute their SLOs. 
module "slo-generator" {
  source                = "../../../modules/slo-generator"
  project_id            = var.project_id
  region                = var.region
  config                = local.sre_config
  service_account_email = local.service_account_email
  slo_configs = local.sre_slo_configs
  secrets = merge(var.secrets, {
    TEAM1_PROJECT_ID      = var.team1_project_id,
    SRE_PROJECT_ID        = var.project_id,
    SRE_PUBSUB_TOPIC_NAME = var.pubsub_topic_name,
    BIGQUERY_DATASET_ID   = google_bigquery_dataset.export-dataset.dataset_id
  })
}

# SA for slo-generator service
resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = "slo-generator"
  display_name = "SLO Generator Service Account"
}

# SA needs to read from GCS buckets containing SLOs in team projects
resource "google_project_iam_member" "object-viewer" {
  count   = length(local.projects)
  project = local.projects[count.index]
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${local.service_account_email}"
}

# SA needs to read metrics from Cloud Ops workspace in team projects
resource "google_project_iam_member" "monitoring-viewer" {
  count   = length(local.projects)
  project = local.projects[count.index]
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${local.service_account_email}"
}

# SA needs to write metrics to Cloud Ops workspace in team projects
resource "google_project_iam_member" "monitoring-metric-writer" {
  count   = length(local.projects)
  project = local.projects[count.index]
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${local.service_account_email}"
}
