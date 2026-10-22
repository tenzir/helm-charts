A configurable startup probe gives nodes with large partition catalogs time to start before liveness checks begin. Kubernetes version labels now reflect the configured image tag.

## 🚀 Features

### Optional startup probe for slow partition-catalog boots

Nodes with large partition catalogs can boot for minutes before the node API accepts connections. A new `startupProbe` (enabled by default, `tcpSocket` on the node port, 10s period, 60-failure threshold) holds off liveness and readiness checks until the first success, so the liveness probe no longer restarts the container mid-boot. Set `startupProbe.enabled: false` to keep the previous behavior.

*By @Apocrathia in #10.*

## 🔧 Changes

### Version label follows the configured image tag

The `app.kubernetes.io/version` label now reports `image.tag` when you set it, falling back to the chart's `appVersion` otherwise. Previously the label always showed the chart's `appVersion`, even when a different image tag was deployed.

*By @sam-vermeulen-ocd and @Zedoraps in #7.*
