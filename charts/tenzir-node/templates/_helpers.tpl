{{/*
Expand the name of the chart.
*/}}
{{- define "tenzir-node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "tenzir-node.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tenzir-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "tenzir-node.labels" -}}
helm.sh/chart: {{ include "tenzir-node.chart" . }}
{{ include "tenzir-node.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "tenzir-node.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tenzir-node.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Resource-safe name for a configured Tenzir node.
*/}}
{{- define "tenzir-node.nodeName" -}}
{{- $root := .root -}}
{{- $node := .node -}}
{{- printf "%s-%s" (include "tenzir-node.fullname" $root) $node.name | lower | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Name of the ConfigMap containing a node's tenzir.yaml.
*/}}
{{- define "tenzir-node.configMapName" -}}
{{- printf "%s-config" (include "tenzir-node.nodeName" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels for one configured Tenzir node.
*/}}
{{- define "tenzir-node.nodeSelectorLabels" -}}
{{ include "tenzir-node.selectorLabels" .root }}
app.kubernetes.io/component: node
app.kubernetes.io/tenzir-node: {{ .node.name | quote }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "tenzir-node.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tenzir-node.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the headless service used by the StatefulSet.
*/}}
{{- define "tenzir-node.headlessServiceName" -}}
{{- printf "%s-headless" (include "tenzir-node.nodeName" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Name of the Secret that contains TENZIR_TOKEN.
*/}}
{{- define "tenzir-node.tokenSecretName" -}}
{{- $node := .node -}}
{{- $token := default dict $node.token -}}
{{- if $token.existingSecret }}
{{- $token.existingSecret }}
{{- else }}
{{- printf "%s-token" (include "tenzir-node.nodeName" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Container image reference (registry/repository:tag).
*/}}
{{- define "tenzir-node.image" -}}
{{- $reg := .Values.image.registry | default "" -}}
{{- $repo := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- if $reg -}}
{{ $reg }}/{{ $repo }}:{{ $tag }}
{{- else -}}
{{ $repo }}:{{ $tag }}
{{- end -}}
{{- end }}

{{/*
Merged tenzir.yaml for one node as a YAML string.
Used by both configmap.yaml (to populate the ConfigMap) and statefulset.yaml
(to compute a per-node checksum that triggers a rolling restart on change).

Call with: (dict "root" $ "node" $node).
*/}}
{{- define "tenzir-node.mergedConfig" -}}
{{- $root := .root -}}
{{- $node := .node -}}
{{- $defaults := dict
    "endpoint" "0.0.0.0:5158"
    "file-verbosity" "quiet"
    "console-sink" "stderr"
  -}}
{{- $merged := mergeOverwrite (deepCopy (default dict $root.Values.tenzir.config)) (default dict $node.config) -}}
{{- $tenzir := mergeOverwrite (deepCopy $defaults) (default dict (get $merged "tenzir")) -}}
{{- $_ := set $merged "tenzir" $tenzir -}}
{{- toYaml $merged -}}
{{- end }}

{{/*
Pod label key marking participation in a sharedServices[] entry.
*/}}
{{- define "tenzir-node.sharedLabelKey" -}}
{{- printf "tenzir.io/shared-%s" .name -}}
{{- end }}

{{/*
Resolved list of node names targeted by a sharedServices[] entry.
Omitting `nodes` (or passing the string "all") expands to every configured
node. Otherwise the configured list is used as-is.
*/}}
{{- define "tenzir-node.sharedTargetNodes" -}}
{{- $root := .root -}}
{{- $svc := .svc -}}
{{- $names := list -}}
{{- $cfg := $svc.nodes -}}
{{- if or (not $cfg) (eq (kindOf $cfg) "string") -}}
  {{- range $n := $root.Values.nodes -}}
    {{- $names = append $names $n.name -}}
  {{- end -}}
{{- else -}}
  {{- range $name := $cfg -}}
    {{- $names = append $names $name -}}
  {{- end -}}
{{- end -}}
{{- toJson $names -}}
{{- end }}
