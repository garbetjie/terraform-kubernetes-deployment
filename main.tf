resource kubernetes_deployment deployment {
  wait_for_rollout = var.wait_for_rollout

  metadata {
    namespace = var.namespace
    name = var.name
    labels = local.labels
  }
  spec {
    replicas = var.replicas

    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        deployment = var.name
      }
    }

    template {
      metadata {
        labels = local.labels
      }
      spec {
        node_selector = var.node_selector

        dynamic "toleration" {
          for_each = var.tolerations
          content {
            key = toleration.value.key
            value = toleration.value.value
          }
        }

        container {
          name = "worker"
          image = var.image
          image_pull_policy = "Always"
          args = var.args

          resources {
            limits {
              memory = "${var.memory}Mi"
            }
            requests {
              cpu = "${var.cpu * 1000}m"
            }
          }

          dynamic "env" {
            for_each = var.env
            content {
              name = env.key
              value = env.value
            }
          }

          dynamic "env_from" {
            for_each = var.env_from_secrets
            content {
              secret_ref {
                name = env_from.value
              }
            }
          }

          dynamic "volume_mount" {
            for_each = local.mount_host_paths
            content {
              mount_path = volume_mount.value.mount_path
              name = volume_mount.key
            }
          }

          dynamic "volume_mount" {
            for_each = local.mount_secrets
            content {
              mount_path = volume_mount.value.path
              name = volume_mount.key
            }
          }
        }

        dynamic "init_container" {
          for_each = var.init_containers

          content {
            name = "init-${init_container.key}"
            args = init_container.value.args

            dynamic "env" {
              for_each = init_container.value.env
              content {
                name = env.key
                value = env.value
              }
            }

            dynamic "volume_mount" {
              for_each = local.mount_host_paths
              content {
                mount_path = volume_mount.value.mount_path
                name = volume_mount.key
              }
            }

            dynamic "volume_mount" {
              for_each = local.mount_secrets
              content {
                mount_path = volume_mount.value.path
                name = volume_mount.key
              }
            }
          }
        }

        dynamic "volume" {
          for_each = local.mount_host_paths
          content {
            name = volume.key
            host_path {
              path = volume.value.host_path
              type = "Directory"
            }
          }
        }

        dynamic "volume" {
          for_each = local.mount_secrets
          content {
            name = volume.key
            secret {
              secret_name = volume.value.secret
              optional = false
              dynamic "items" {
                for_each = volume.value.items
                content {
                  key = items.value
                  path = items.value
                }
              }
            }
          }
        }
      }
    }
  }
}
