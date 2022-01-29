locals {
  team1_config = yamldecode(file("${path.module}/configs/team1/config.yaml"))
  team1_configs = [
    for cfg in fileset(path.module, "/configs/team1/slo_*.yaml") :
    yamldecode(file(cfg))
  ]
  team2_configs = [
    for cfg in fileset(path.module, "/configs/team2/slo_*.yaml") :
    yamldecode(file(cfg))
  ]
}

# Team 1 computes their own SLOs, and sets up an exporter to SRE's BigQuery
# dataset.
module "team1-slos" {
  source                = "../../../modules/slo-generator"
  project_id            = var.team1_project_id
  region                = var.region
  config                = local.team1_config
  slo_configs           = local.team1_configs
  gcr_project_id        = var.team1_project_id
  slo_generator_version = var.slo_generator_version
  secrets = {
    SRE_PROJECT_ID          = var.project_id
    SRE_BIGQUERY_DATASET_ID = google_bigquery_dataset.export-dataset.dataset_id
    PROJECT_ID              = var.team1_project_id
  }
}

# Team 2 manages a GCS bucket with their SLO configs, but wants to use
# SRE-as-a-service.
module "team2-slos" {
  source         = "../../../modules/slo-generator"
  project_id     = var.team2_project_id
  region         = var.region
  slo_configs    = local.team2_configs
  service_url    = module.slo-generator.service_url
  create_service = false
}
