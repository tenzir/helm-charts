---
title: Version label follows the configured image tag
type: change
authors:
  - sam-vermeulen-ocd
  - Zedoraps
prs:
  - 7
created: 2026-06-23T08:17:06.379766Z
---

The `app.kubernetes.io/version` label now reports `image.tag` when you set it,
falling back to the chart's `appVersion` otherwise. Previously the label always
showed the chart's `appVersion`, even when a different image tag was deployed.
