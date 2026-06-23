---
title: Hardened container security defaults
type: feature
authors:
  - Zedoraps
  - claude
prs:
  - 2
created: 2026-06-17T07:02:15.05769Z
---

Container `securityContext` ships hardened by default: `runAsNonRoot: true` with `runAsUser` and `runAsGroup` pinned to `999` (matching the image's `tenzir` user), `seccompProfile: { type: RuntimeDefault }`, `allowPrivilegeEscalation: false`, `capabilities.drop: [ALL]`, and `readOnlyRootFilesystem: true`. An `emptyDir` mounted at `/tmp` keeps the writable surface to just that path and the `/var/lib/tenzir` PVC.
