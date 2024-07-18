variable "namespace" {
  description = "Namespace for GitHub Actions Runner"
  type        = string
  default     = "arc-runners"
}

variable "repository_url" {
  description = "URL of the GitHub repository"
  type        = string
  default     = "https://github.com/jco281/sampleIAC"
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}
