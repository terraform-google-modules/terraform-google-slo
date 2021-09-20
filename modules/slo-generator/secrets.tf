data "google_project" "project" {
  project_id = var.project_id
}

resource "google_secret_manager_secret" "secret" {
  for_each  = var.secrets
  provider  = google-beta
  project   = var.project_id
  secret_id = each.key
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_iam_member" "secret-access" {
  for_each  = google_secret_manager_secret.secret
  provider  = google-beta
  project   = var.project_id
  secret_id = each.value.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${local.service_account_email}"
}

resource "google_secret_manager_secret_version" "secret-version-data" {
  for_each    = google_secret_manager_secret.secret
  provider    = google-beta
  secret      = each.value.id
  secret_data = var.secrets[each.key]
}


