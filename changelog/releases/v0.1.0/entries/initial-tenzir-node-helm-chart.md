---
title: Initial Tenzir Node Helm chart
type: feature
authors:
  - Zedoraps
  - claude
prs:
  - 2
created: 2026-06-17T07:01:57.348797Z
---

Install the chart from `oci://ghcr.io/tenzir/charts/tenzir-node` to deploy one or more `tenzir-node` instances on Kubernetes. Each entry in the chart's `nodes` list renders as its own one-pod `StatefulSet` with a dedicated `Service`, `ConfigMap`, `Secret`, and persistent volume claim, scaled independently of the others.
