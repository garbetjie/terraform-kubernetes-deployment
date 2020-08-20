output name {
  value = kubernetes_deployment.deployment.metadata[0].name
}

output labels {
  value = kubernetes_deployment.deployment.metadata[0].labels
}
