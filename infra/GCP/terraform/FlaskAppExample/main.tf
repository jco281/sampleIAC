provider "google" {
  project = var.project
  region  = var.region
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
      source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.app_zip.name}"
    }
  }
  entrypoint {
    shell = "gunicorn -b :$PORT app:app"
  }
  delete_service_on_destroy = true
}

resource "google_storage_bucket" "bucket" {
  name     = "${var.project}-app-bucket"
  location = var.region
}

data "archive_file" "app_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/app.zip"

  excludes = [
    "**/terraform.tfstate",
    "**/terraform.tfstate.backup",
    "**/.terraform/**",
  ]
}

resource "google_storage_bucket_object" "app_zip" {
  name   = "app.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.app_zip.output_path
}

output "app_url" {
  value = "https://${google_app_engine_standard_app_version.app.service}.appspot.com"
}
