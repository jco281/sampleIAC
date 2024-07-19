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
    value = "1"
  }

  set {
    name  = "maxRunners"
    value = "5"
  }

  set {
    name  = "containerMode.type"
    value = "dind"
  }

  set {
    name  = "template.spec.initContainers[0].name"
    value = "init-dind-externals"
  }

  set {
    name  = "template.spec.initContainers[0].image"
    value = "ghcr.io/actions/actions-runner:latest"
  }

  set {
    name  = "template.spec.initContainers[0].command[0]"
    value = "cp"
  }

  set {
    name  = "template.spec.initContainers[0].command[1]"
    value = "-r"
  }

  set {
    name  = "template.spec.initContainers[0].command[2]"
    value = "-v"
  }

  set {
    name  = "template.spec.initContainers[0].command[3]"
    value = "/home/runner/externals/."
  }

  set {
    name  = "template.spec.initContainers[0].command[4]"
    value = "/home/runner/tmpDir/"
  }

  set {
    name  = "template.spec.initContainers[0].volumeMounts[0].name"
    value = "dind-externals"
  }

  set {
    name  = "template.spec.initContainers[0].volumeMounts[0].mountPath"
    value = "/home/runner/tmpDir"
  }

  set {
    name  = "template.spec.containers[0].name"
    value = "runner"
  }

  set {
    name  = "template.spec.containers[0].image"
    value = "ghcr.io/actions/actions-runner:latest"
  }

  set {
    name  = "template.spec.containers[0].command[0]"
    value = "/home/runner/run.sh"
  }

  set {
    name  = "template.spec.containers[0].env[0].name"
    value = "DOCKER_HOST"
  }

  set {
    name  = "template.spec.containers[0].env[0].value"
    value = "unix:///var/run/docker.sock"
  }

  set {
    name  = "template.spec.containers[0].volumeMounts[0].name"
    value = "work"
  }

  set {
    name  = "template.spec.containers[0].volumeMounts[0].mountPath"
    value = "/home/runner/_work"
  }

  set {
    name  = "template.spec.containers[0].volumeMounts[1].name"
    value = "dind-sock"
  }

  set {
    name  = "template.spec.containers[0].volumeMounts[1].mountPath"
    value = "/var/run"
  }

  set {
    name  = "template.spec.containers[1].name"
    value = "dind"
  }

  set {
    name  = "template.spec.containers[1].image"
    value = "docker:dind"
  }

  set {
    name  = "template.spec.containers[1].args[0]"
    value = "dockerd"
  }

  set {
    name  = "template.spec.containers[1].args[1]"
    value = "--host=unix:///var/run/docker.sock"
  }

  set {
    name  = "template.spec.containers[1].args[2]"
    value = "--group=$(DOCKER_GROUP_GID)"
  }

  set {
    name  = "template.spec.containers[1].env[0].name"
    value = "DOCKER_GROUP_GID"
  }

  set {
    name  = "template.spec.containers[1].securityContext.privileged"
    value = "true"
  }

  set {
    name  = "template.spec.containers[1].volumeMounts[0].name"
    value = "work"
  }

  set {
    name  = "template.spec.containers[1].volumeMounts[0].mountPath"
    value = "/home/runner/_work"
  }

  set {
    name  = "template.spec.containers[1].volumeMounts[1].name"
    value = "dind-sock"
  }

  set {
    name  = "template.spec.containers[1].volumeMounts[1].mountPath"
    value = "/var/run"
  }

  set {
    name  = "template.spec.containers[1].volumeMounts[2].name"
    value = "dind-externals"
  }

  set {
    name  = "template.spec.containers[1].volumeMounts[2].mountPath"
    value = "/home/runner/externals"
  }

  set {
    name  = "template.spec.volumes[0].name"
    value = "work"
  }

  set {
    name  = "template.spec.volumes[0].emptyDir.medium"
    value = ""
  }

  set {
    name  = "template.spec.volumes[1].name"
    value = "dind-sock"
  }

  set {
    name  = "template.spec.volumes[1].emptyDir.medium"
    value = ""
  }

  set {
    name  = "template.spec.volumes[2].name"
    value = "dind-externals"
  }

  set {
    name  = "template.spec.volumes[2].emptyDir.medium"
    value = ""
  }

}

# Outputs

output "arc_systems_namespace" {
  value = kubernetes_namespace.arc_systems.metadata[0].name
}

output "arc_runners_namespace" {
  value = kubernetes_namespace.arc_runners.metadata[0].name
}
