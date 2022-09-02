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
