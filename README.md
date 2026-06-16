# Tenzir Helm Charts

This repository hosts the official Helm charts for deploying
[Tenzir](https://docs.tenzir.com) on Kubernetes.

## Charts

| Chart | Purpose |
|---|---|
| [`charts/tenzir-node`](charts/tenzir-node) | Deploy one or more static `tenzir-node` instances. |

## Install

```sh
helm install tenzir-node charts/tenzir-node \
  -n tenzir --create-namespace \
  -f my-values.yaml
```

See [`charts/tenzir-node/README.md`](charts/tenzir-node/README.md) for the
full configuration reference and a worked walkthrough.

## Local validation

The chart ships a values schema, kubeconform-friendly manifests, and is
designed to pass Trivy's container-hardening rules at HIGH severity. Install
[`helm`](https://helm.sh), [`kubeconform`](https://github.com/yannh/kubeconform),
and [`trivy`](https://trivy.dev) however you prefer (Nix, Homebrew, package
managers, prebuilt binaries) and run:

```sh
# Lint the chart against its values schema.
helm lint charts/tenzir-node

# Validate the rendered manifests against the Kubernetes API schemas.
helm template tn charts/tenzir-node -f examples/full.yaml \
  | kubeconform -strict -summary -kubernetes-version 1.33.3 -

# Render with a realistic values file, then scan for misconfigurations.
trivy config charts/tenzir-node \
  --helm-values examples/full.yaml \
  --severity HIGH,CRITICAL,MEDIUM

# Render to stdout for ad-hoc inspection.
helm template tn charts/tenzir-node -f examples/full.yaml
```

`examples/full.yaml` exercises most chart knobs (port modes, sharedServices,
NetworkPolicy, PodDisruptionBudget, pipelines-as-code) and pins the image
tag so renders are stable.

## Community

Got questions? Join our
[community Discord](https://discord.gg/xqbDgVTCxZ) — a friendly group of
folks working at the intersection of data infrastructure and security
operations.
