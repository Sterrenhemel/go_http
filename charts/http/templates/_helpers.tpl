{{/*
Expand the name of the chart.
*/}}
{{- define "http.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "http.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := .Values.serviceType }}
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
{{- define "http.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "http.labels" -}}
helm.sh/chart: {{ include "http.chart" . }}
{{ include "http.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "http.selectorLabels" -}}
app.kubernetes.io/name: {{ include "http.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "http.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "http.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "ingress.dnshost_tmp" -}}
{{- if .Values.ingress.enabled }}
{{- range .Values.ingress.hosts }}
{{- .host }},
{{- end }}
{{- end }}
{{- end }}

{{- define "ingress.dnshost" -}}
{{- if .Values.ingress.enabled }}
{{- "external-dns.alpha.kubernetes.io/hostname: "}} {{- include "ingress.dnshost_tmp" . | trimSuffix ","  }}
{{- end }}
{{- end }}