---
title: Per-node configuration with checksum-driven rollouts
type: feature
authors:
  - Zedoraps
  - claude
prs:
  - 2
created: 2026-06-17T07:02:13.28202Z
---

Compose each node's `tenzir.yaml` from a global `tenzir.config` overlay merged with each entry's `nodes[].config`. A per-node `checksum/config` annotation on the pod template ensures `helm upgrade` only rolls the pods whose merged configuration actually changed; untouched nodes keep running.
