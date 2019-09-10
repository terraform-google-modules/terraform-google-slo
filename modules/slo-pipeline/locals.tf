locals {
  bigquery_configs = [for e in var.exporters : e if lower(e.class) == "bigquery"]
  sd_configs       = [for e in var.exporters : e if lower(e.class) == "stackdriver"]
}
