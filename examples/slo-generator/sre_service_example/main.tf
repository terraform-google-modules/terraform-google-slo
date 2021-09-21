# SRE team provides the slo-generator as-a-service.

# This files set up the slo-generator service along with service accounts and 
# IAM permissions needed to operate it.

locals {
  config                = yamldecode(file("configs/config.yaml"))
  service_account_email = google_service_account.service_account.email
}

# SLOs as-a-service, run by SRE team. 
# This service can be used by the various teams to compute their SLOs. 
# It always export to BigQuery and PubSub.
module "slo-generator" {
  source                = "../../../modules/slo-generator"
  project_id            = var.project_id
  region                = var.region
  config                = local.config
  service_account_email = local.service_account_email
  secrets = merge(var.secrets, {
    TEAM1_PROJECT_ID      = var.team1_project_id,
    TEAM2_PROJECT_ID      = var.team2_project_id,
    SRE_PROJECT_ID        = var.project_id,
    SRE_PUBSUB_TOPIC_NAME = var.pubsub_topic_name,
    BIGQUERY_DATASET_ID   = google_bigquery_dataset.export-dataset_id
  })
}
