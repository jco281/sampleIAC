provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "github_actions" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_persistent_volume_claim" "runner_workdir" {
  metadata {
    name      = "runner-workdir"
    namespace = kubernetes_namespace.github_actions.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}


resource "kubernetes_deployment" "runner" {
  metadata {
    name      = "github-actions-runner"
    namespace = kubernetes_namespace.github_actions.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "github-actions-runner"
      }
    }

    template {
      metadata {
        labels = {
          app = "github-actions-runner"
        }
      }

      spec {
        container {
          name  = "github-actions-runner"
          image = "myoung34/github-runner:latest"

          env {
            name  = "RUNNER_NAME"
            value = "local-runner"
          }

          env {
            name  = "RUNNER_REPOSITORY_URL"
            value = var.repository_url
          }

          env {
            name = "REPO_URL"
            value = var.repository_url
          }

          env {
            name  = "RUNNER_TOKEN"
            value = var.runner_token
          }

          env {
            name  = "RUNNER_WORKDIR"
            value = "/tmp/github-runner"
          }

          volume_mount {
            name       = "runner-workdir"
            mount_path = "/tmp/github-runner"
          }
        }
        volume {
          name = "runner-workdir"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.runner_workdir.metadata[0].name
          }
        }
      }
    }
  }
}

output "runner_instance_id" {
  value = kubernetes_deployment.runner.metadata[0].name
}