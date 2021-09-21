# Pubsub topic to export SLOs to
resource "google_pubsub_topic" "export-topic" {
  project = var.project_id
  name    = var.pubsub_topic_name
}

resource "google_pubsub_topic_iam_member" "pubsub-publisher" {
  project = google_pubsub_topic.export-topic.project
  topic   = google_pubsub_topic.export-topic.name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${local.service_account_email}"
}


# BigQuery dataset to export SLOs to
resource "google_bigquery_dataset" "export-dataset" {
  project       = var.project_id
  dataset_id    = var.bigquery_dataset_name
  friendly_name = "slos"
  description   = "SLO Reports"
  location      = "EU"
  access {
    role          = "OWNER"
    user_by_email = local.service_account_email
  }
}
