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

module "team1-slos" {
  source      = "../../../modules/slo-generator"
  project_id  = var.team1_project_id
  region      = var.region
  slo_configs = local.team1_configs
}

module "team2-slos" {
  source      = "../../../modules/slo-generator"
  project_id  = var.team2_project_id
  region      = var.region
  slo_configs = local.team2_configs
  service_url = module.slo-generator.service_url
}
