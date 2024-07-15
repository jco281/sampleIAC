provider "google" {
  project = var.project
  region  = var.region
  credentials = file(var.credentials_file)
}

resource "google_app_engine_application" "app" {
  location_id = var.region
}

resource "google_app_engine_standard_app_version" "app" {
  service     = "default"
  version_id  = "v1"
  runtime     = "python39"

  deployment {
    zip {
      source_url = "gs://${google_storage_bucket.bucket.name}/app.zip"
    }
  }
}

resource "google_storage_bucket" "bucket" {
  name     = "${var.project}-app-bucket"
  location = var.region
}

output "app_url" {
  value = "https://${google_app_engine_standard_app_version.app.service}.appspot.com"
}
