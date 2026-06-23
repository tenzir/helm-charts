---
title: Optional NetworkPolicy and PodDisruptionBudget
type: feature
authors:
  - Zedoraps
  - claude
prs:
  - 2
created: 2026-06-17T07:02:16.009252Z
---

Render an optional `NetworkPolicy` scoping ingress to the node pods by setting `networkPolicy.enabled: true`. Render an optional `PodDisruptionBudget` spanning every node pod in the release by setting `podDisruptionBudget.minAvailable` or `podDisruptionBudget.maxUnavailable`. Neither resource is rendered with the chart defaults.
