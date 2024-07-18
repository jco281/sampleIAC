provider "google" {
  project = var.project
  region  = var.region
}

resource "google_storage_bucket" "bucket" {
  name     = var.bucket_name
  location = var.region
}

output "bucket_url" {
  value = "gs://${google_storage_bucket.bucket.name}"
}
