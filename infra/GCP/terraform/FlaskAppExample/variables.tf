variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}
variable "source_dir" {
  description = "Path to the source directory containing application files"
  type        = string
}
