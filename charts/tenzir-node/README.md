# Tenzir Node Helm Chart

This chart deploys one or more static `tenzir-node` instances on
Kubernetes. Each entry in `nodes` renders as its own StatefulSet with a
persistent volume and a Kubernetes Service.

For installation and update walkthroughs, see
[Deploy a node → Kubernetes](https://docs.tenzir.com/guides/node-setup/deploy-a-node#kubernetes).
For the option surface — ports, NetworkPolicy, container hardening, and
how the chart triggers per-node rollouts — see the
[Helm chart explanation](https://docs.tenzir.com/explanations/node/helm-chart).

## Install

```sh
helm install tenzir-node oci://ghcr.io/tenzir/charts/tenzir-node \
  --version 0.1.0 \
  --namespace tenzir --create-namespace \
  -f values.yaml
```

A minimal `values.yaml` references a pre-created Secret that holds the
node's `TENZIR_TOKEN`:

```yaml
nodes:
  - name: default
    token:
      existingSecret: tenzir-node-token
```

## Values

The full default values live in
[`values.yaml`](values.yaml) and are validated against
[`values.schema.json`](values.schema.json). Below are the values you reach
for most often.

| Value | Default | Description |
| --- | --- | --- |
| `nodes` | required | One entry per pre-provisioned platform node. |
| `nodes[].name` | required | Used in every Kubernetes resource name and label. |
| `nodes[].token.value` | `""` | Inline token; the chart creates a Secret for it. Mutually exclusive with `existingSecret`. |
| `nodes[].token.existingSecret` | `""` | Name of an existing Secret holding `TENZIR_TOKEN`. Mutually exclusive with `value`. |
| `nodes[].token.key` | `TENZIR_TOKEN` | Data key inside the Secret. |
| `nodes[].config` | `{}` | Per-node `tenzir.yaml` overlay. |
| `nodes[].extraPorts` | `[]` | Extra container ports on this one node. |
| `tenzir.config` | `{}` | Global `tenzir.yaml` overlay merged into every node. |
| `sharedServices` | `[]` | Fleet-wide Services that load-balance a port across multiple nodes. |
| `image.registry` | `docker.io` | Image registry prefix. |
| `image.repository` | `tenzir/tenzir` | Image repository. |
| `image.tag` | `latest` | Override with a pinned version for production deployments. |
| `containerSecurityContext` | hardened defaults | See the [Helm chart explanation](https://docs.tenzir.com/explanations/node/helm-chart#harden-the-deployment). |
| `networkPolicy.enabled` | `false` | When `true`, renders a NetworkPolicy across the node pods. |
| `podDisruptionBudget` | `{}` | Set `minAvailable` or `maxUnavailable` to render a PDB. |
| `persistence.enabled` | `true` | Persist `/var/lib/tenzir` through a PersistentVolumeClaim. |
| `persistence.size` | `10Gi` | Per-node state volume size. |

Anything you put under `tenzir.config` or `nodes[].config` lands in a
ConfigMap in plaintext. Do not put secrets there. Use `nodes[].token` for
the node token, and `extraEnv` with a `valueFrom.secretKeyRef` for other
sensitive values.

## Resources rendered per node

- One `StatefulSet` with one replica
- One `Service` (ClusterIP) and one headless `Service`
- One `ConfigMap` carrying the node's `tenzir.yaml`
- One `Secret` (only when `token.value` is set)
- One `PersistentVolumeClaim` (when `persistence.enabled`)
- One test `Pod` (`helm test` hook) that runs `tenzir api "/ping"`

Cluster-wide resources rendered once per release:

- One `ServiceAccount` (when `serviceAccount.create: true`)
- One `NetworkPolicy` (when `networkPolicy.enabled: true`)
- One `PodDisruptionBudget` (when `podDisruptionBudget` has a constraint)
- One `Service` per `sharedServices[]` entry
