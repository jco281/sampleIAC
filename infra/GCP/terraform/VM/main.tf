provider "google" {
  project = var.project
  region  = var.region
  credentials = file(var.credentials_file)
}

resource "google_compute_instance" "default" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }
}

output "instance_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
