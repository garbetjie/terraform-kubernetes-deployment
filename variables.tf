variable name {
  type = string
}

variable namespace {
  type = string
}

variable image {
  type = string
}

variable args {
  type = list(string)
}

variable replicas {
  type = number
  default = 1
}

variable labels {
  type = map(string)
  default = {}
}

variable env {
  type = map(string)
  default = {}
}

variable cpu {
  type = number
  default = 0.1
}

variable memory {
  type = number
  default = 128
}

variable env_from_secrets {
  type = set(string)
  default = []
}

variable wait_for_rollout {
  type = bool
  default = true
}

variable mount_host_path {
  type = string
  default = null
}

variable init_containers {
  type = list(object({ args = list(string), env = map(string) }))
  default = []
}

variable volumes_from_secrets {
  type = list(object({ secret = string, path = string, items = set(string) }))
  default = []
}

locals {
  labels = merge(var.labels, { deployment = var.name })
  volumes_from_secrets = {
    for index, vfs in var.volumes_from_secrets:
      "${vfs.secret}:${vfs.path}" => vfs
  }
}