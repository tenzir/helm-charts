---
title: Optional startup probe for slow partition-catalog boots
type: feature
authors:
  - Apocrathia
prs:
  - 10
created: 2026-10-17T23:53:31.716481Z
---

Nodes with large partition catalogs can boot for minutes before the node API
accepts connections. A new `startupProbe` (enabled by default, `tcpSocket` on
the node port, 10s period, 60-failure threshold) holds off liveness and
readiness checks until the first success, so the liveness probe no longer
restarts the container mid-boot. Set `startupProbe.enabled: false` to keep the
previous behavior.
