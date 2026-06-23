Initial release of the Tenzir Node Helm chart.

## 🚀 Features

### Hardened container security defaults

Container `securityContext` ships hardened by default: `runAsNonRoot: true` with `runAsUser` and `runAsGroup` pinned to `999` (matching the image's `tenzir` user), `seccompProfile: { type: RuntimeDefault }`, `allowPrivilegeEscalation: false`, `capabilities.drop: [ALL]`, and `readOnlyRootFilesystem: true`. An `emptyDir` mounted at `/tmp` keeps the writable surface to just that path and the `/var/lib/tenzir` PVC.

*By @Zedoraps and @claude in #2.*

### Initial Tenzir Node Helm chart

Install the chart from `oci://ghcr.io/tenzir/charts/tenzir-node` to deploy one or more `tenzir-node` instances on Kubernetes. Each entry in the chart's `nodes` list renders as its own one-pod `StatefulSet` with a dedicated `Service`, `ConfigMap`, `Secret`, and persistent volume claim, scaled independently of the others.

*By @Zedoraps and @claude in #2.*

### Optional NetworkPolicy and PodDisruptionBudget

Render an optional `NetworkPolicy` scoping ingress to the node pods by setting `networkPolicy.enabled: true`. Render an optional `PodDisruptionBudget` spanning every node pod in the release by setting `podDisruptionBudget.minAvailable` or `podDisruptionBudget.maxUnavailable`. Neither resource is rendered with the chart defaults.

*By @Zedoraps and @claude in #2.*

### Per-node configuration with checksum-driven rollouts

Compose each node's `tenzir.yaml` from a global `tenzir.config` overlay merged with each entry's `nodes[].config`. A per-node `checksum/config` annotation on the pod template ensures `helm upgrade` only rolls the pods whose merged configuration actually changed; untouched nodes keep running.

*By @Zedoraps and @claude in #2.*

### Two patterns for exposing listener ports

Open additional listener ports through `nodes[].extraPorts`, which attaches a port to one specific node's pod and Service (optionally backed by its own dedicated `Service` when `serviceType` is set), or through `sharedServices`, which creates a single fleet-wide `Service` whose endpoints span every selected node's pod so kube-proxy load-balances across them.

*By @Zedoraps and @claude in #2.*
