variable "org_id" {
  description = "Organization id"
}

variable "folder_id" {
  description = "Folder id"
}

variable "billing_account" {
  description = "Billing account id"
}

variable "bucket_name" {
  description = "GCS bucket name to create"
}

variable "project_name" {
  description = "Project name"
  default     = "slo-pipeline"
}

variable "stackdriver_host_project_id" {
  description = "Stackdriver host project id"
}

variable "region" {
  description = "Region"
}

variable "labels" {
  description = "Project labels"
  default     = {}
}

variable "credentials_path" {
  description = "Path to gcloud credentials"
}
