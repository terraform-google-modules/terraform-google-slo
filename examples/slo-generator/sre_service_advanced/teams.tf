locals {
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
  slo_configs           = local.team1_configs
  gcr_project_id        = var.team1_project_id
  slo_generator_version = var.slo_generator_version
  secrets = {
    SRE_BIGQUERY_DATASET_ID = google_bigquery_dataset.export-dataset.dataset_id
    PROJECT_ID              = var.team1_project_id
  }
}

module "team2-slos" {
  source      = "../../../modules/slo-generator"
  project_id  = var.team2_project_id
  region      = var.region
  slo_configs = local.team2_configs
  service_url = module.slo-generator.service_url
}
