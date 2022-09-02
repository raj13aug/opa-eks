
# https://github.com/siddkhaiwal007/safe-gke-cluster/tree/89ef266270a719dc516d5d32692649d0937a1010/modules/k8s-gatekeeper/helm-gatekeeper-templates/templates

variable "namespace" {
  description = "Name of the gatekeeper namespace"
  type        = string
  default     = "gatekeeper-system"
}

variable "helm_release_name" {
  description = "Name of the gatekeeper helm release"
  type        = string
  default     = "gatekeeper"
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
  chart     = "${path.module}/helm-gatekeeper-templates"
  name      = "gatekeeper-templates"
  namespace = var.namespace
  version   = "0.0.3"

  depends_on = [
    helm_release.gatekeeper
  ]
}

resource "helm_release" "gatekeeper-constraints" {
  chart     = "${path.module}/helm-gatekeeper-constraints"
  name      = "gatekeeper-constraints"
  namespace = var.namespace
  version   = "0.0.3"

  depends_on = [
    helm_release.gatekeeper-templates
  ]
}