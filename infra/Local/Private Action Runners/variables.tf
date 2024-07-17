variable "namespace" {
  description = "Namespace for GitHub Actions Runner"
  type        = string
  default     = "github-actions"
}

variable "runner_name" {
  description = "Name of the GitHub Actions Runner"
  type        = string
  default     = "local-runner"
}

variable "repository_url" {
  description = "URL of the GitHub repository"
  type        = string
  default     = "https://github.com/jco281/sampleIAC"
}

variable "runner_token" {
  description = "GitHub Actions Runner token"
  type        = string
}
