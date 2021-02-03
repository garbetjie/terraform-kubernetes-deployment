Terraform Module: Kubernetes Deployments
========================================

A very simple Terraform module used to easily create and manage a deployment consisting of a single container only.

## Usage

```hcl-terraform
module k8s_deployment {
  name = "my-deployment"
  namespace = "default"
  image = "my/image:latest"
  args = []
}
```

## Inputs

| Name             | Description                                                                                                              | Type                                                                  | Default | Required |
|------------------|--------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|---------|----------|
| name             | Name of the deployment.                                                                                                  | string                                                                |         | Yes      |
| namespace        | Namespace in which to create the deployment.                                                                             | string                                                                |         | Yes      |
| image            | Image to create the deployment with.                                                                                     | string                                                                |         | Yes      |
| args             | Arguments to run the image with.                                                                                         | list(string)                                                          | `[]`    | No       |
| cpu              | CPU limit to set on the pod (sets the request, not the actual limit).                                                    | number                                                                | `0.1`   | No       |
| env              | Environment variables to inject into the created pods.                                                                   | map(string)                                                           | `{}`    | No       |
| env_from_secrets | Names of secrets from which to populate the environment variables.                                                       | set(string)                                                           | `[]`    | No       |
| init_containers  | A list of init containers to use.                                                                                        | list(object({ args=list(string), env=map(string), image=string }))    | `[]`    | No       |
| labels           | Labels to apply to the created pods.                                                                                     | map(string)                                                           | `{}`    | No       |
| memory           | Memory (in MB) limit to set on the pod.                                                                                  | number                                                                | `128`   | No       |
| node_selector    | Labels used to select the node on which to create the deployment.                                                        | map(string)                                                           | `{}`    | No       |
| mount_host_paths | A map of host->container paths to mount into the container. The host path should be the key, and the pod path the value. | map(string)                                                           | `{}`    | No       |
| mount_secrets    | A list of secrets to mount into the container's filesystem.                                                              | list(object({ secret = string, path = string, items = set(string) })) | `[]`    | No       |
| replicas         | Number of replicas to create.                                                                                            | number                                                                | `1`     | No       |
| tolerations      | Tolerations to apply to the created pods.                                                                                | list(object({ key=string, value=string }))                            | `[]`    | No       |
| wait_for_rollout | Wait for the successful rollout of the deployment to complete.                                                           | bool                                                                  | `true`  | No       |

## Outputs

| Name   | Description                               | Type        |
|--------|-------------------------------------------|-------------|
| name   | Name of the created deployment.           | string      |
| labels | Labels applied to the created deployment. | map(string) |

## Changelog

* **1.0.0**
    * Release version 1.
