{{/*
Expand the name of the chart.
*/}}
{{- define "migration.name" -}}
{{- printf "migration" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "migration.fullname" -}}
{{- $componentName := include "migration.name" .  }}
{{- if .Values.migration.fullnameOverride }}
{{- .Values.migration.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $componentName | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "migration.labels" -}}
{{ include "migration.selectorLabels" . }}
{{- if .Values.global.tag }}
app.kubernetes.io/image-version: {{ .Values.global.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/short-name: {{ include "migration.name" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "migration.selectorLabels" -}}
app.kubernetes.io/name: {{ include "migration.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

