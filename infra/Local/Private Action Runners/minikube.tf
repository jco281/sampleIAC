# Providers
provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
# Resources
# Install Cert Manager using Helm
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.15.1"

  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

# Define the namespace for ARC system components
resource "kubernetes_namespace" "arc_systems" {
  metadata {
    name = "arc-systems"
  }
}

# Define the namespace for ARC runner components
resource "kubernetes_namespace" "arc_runners" {
  metadata {
    name = "arc-runners"
  }
}

# Install actions-runner-controller using Helm
resource "helm_release" "actions_runner_controller" {
  depends_on       = [kubernetes_namespace.arc_systems]
  name             = "arc"
  chart            = "gha-runner-scale-set-controller"
  namespace        = kubernetes_namespace.arc_systems.metadata[0].name
  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
  create_namespace = false
}

# Create a secret for the GitHub PAT
resource "kubernetes_secret" "github_pat" {
  metadata {
    name      = "pre-defined-secret"
    namespace = kubernetes_namespace.arc_runners.metadata[0].name
  }

  data = {
    "github_token" = var.github_pat
  }

  type = "Opaque"
}

# Install runner scale set using Helm
resource "helm_release" "runner_scale_set" {
  depends_on       = [helm_release.actions_runner_controller, kubernetes_secret.github_pat]
  name             = "arc-runner-set"
  chart            = "gha-runner-scale-set"
  namespace        = kubernetes_namespace.arc_runners.metadata[0].name
  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
  create_namespace = false

  set {
    name  = "githubConfigUrl"
    value = var.repository_url
  }

  set {
    name  = "githubConfigSecret"
    value = "pre-defined-secret"
  }

  set {
    name  = "minRunners"
    value = 1
  }

  set {
    name  = "maxRunners"
    value = 5
  }

}

# Outputs

output "arc_systems_namespace" {
  value = kubernetes_namespace.arc_systems.metadata[0].name
}

output "arc_runners_namespace" {
  value = kubernetes_namespace.arc_runners.metadata[0].name
}
