provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}


resource "kubernetes_namespace" "staging-app" {
  metadata {
    name = "staging"
  }
}

resource "kubernetes_namespace" "gatekeeper" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "gatekeeper" {
  chart      = "gatekeeper"
  repository = "https://open-policy-agent.github.io/gatekeeper/charts"
  name       = var.helm_release_name
  namespace  = var.namespace
  version    = "3.5.1"

  depends_on = [
    kubernetes_namespace.gatekeeper
  ]
}

resource "helm_release" "gatekeeper-templates" {
  chart     = "${path.root}/helm-gatekeeper-templates"
  name      = "gatekeeper-templates"
  namespace = var.namespace
  version   = "0.0.3"

  depends_on = [
    helm_release.gatekeeper
  ]
}

resource "helm_release" "gatekeeper-constraints" {
  chart     = "${path.root}/helm-gatekeeper-constraints"
  name      = "gatekeeper-constraints"
  namespace = var.namespace
  version   = "0.0.3"

  depends_on = [
    helm_release.gatekeeper-templates
  ]
}