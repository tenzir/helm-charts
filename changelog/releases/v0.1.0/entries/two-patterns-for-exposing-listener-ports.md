---
title: Two patterns for exposing listener ports
type: feature
authors:
  - Zedoraps
  - claude
prs:
  - 2
created: 2026-06-17T07:02:14.212586Z
---

Open additional listener ports through `nodes[].extraPorts`, which attaches a port to one specific node's pod and Service (optionally backed by its own dedicated `Service` when `serviceType` is set), or through `sharedServices`, which creates a single fleet-wide `Service` whose endpoints span every selected node's pod so kube-proxy load-balances across them.
