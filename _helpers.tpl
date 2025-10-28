{{/*
Expand the application name.
Truncate at 63 chars to comply with DNS naming limits.
*/}}
{{- define "your-chart.appName" -}}
{{- default .Release.Name .Values.appName | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version for chart label.
*/}}
{{- define "your-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for all Kubernetes objects.
*/}}
{{- define "your-chart.labels" -}}
helm.sh/chart: {{ include "your-chart.chart" . }}
{{ include "your-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels used for matching resources.
*/}}
{{- define "your-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "your-chart.appName" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "your-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "your-chart.appName" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the ConfigMap to use.
*/}}
{{- define "your-chart.configMapName" -}}
{{- if and (eq .Values.isSharedNamespace "true") .Values.configMapName }}
{{- printf "%s-%s" .Values.configMapName .Values.envName }}
{{- else if .Values.configMapName }}
{{- .Values.configMapName }}
{{- else }}
{{- printf "%s-cm" (include "your-chart.appName" .) }}
{{- end }}
{{- end }}

{{/*
Create the name of the AppDynamics ConfigMap to use.
*/}}
{{- define "your-chart.appdConfigMapName" -}}
{{- if and (eq .Values.isSharedNamespace "true") .Values.appdynamics.configMap }}
{{- printf "%s-%s" .Values.appdynamics.configMap .Values.envName }}
{{- else if .Values.appdynamics.configMap }}
{{- .Values.appdynamics.configMap }}
{{- else }}
{{- printf "%s-appdcm" (include "your-chart.appName" .) }}
{{- end }}
{{- end }}

{{/*
Create the name of the SecretProviderClass to use.
*/}}
{{- define "your-chart.secretProviderClassName" -}}
{{- if and (eq .Values.isSharedNamespace "true") .Values.secretConfig.existingSecretProviderClass }}
{{- printf "%s-%s" .Values.secretConfig.existingSecretProviderClass .Values.envName }}
{{- else if .Values.secretConfig.existingSecretProviderClass }}
{{- .Values.secretConfig.existingSecretProviderClass }}
{{- else }}
{{- printf "vault-%s" (include "your-chart.appName" .) }}
{{- end }}
{{- end }}

{{/*
Create the subdomain for the service.
*/}}
{{- define "your-chart.subdomain" -}}
{{- if or (eq .Values.isSharedNamespace "true") .Values.removeEnvPrefix }}
{{- include "your-chart.appName" . }}
{{- else }}
{{- printf "%s-%s" .Values.envName (include "your-chart.appName" .) }}
{{- end }}
{{- end }}


{{/*
Create the AppDynamics tier name.
*/}}
{{- define "your-chart.appdTierName" -}}
{{- printf "tke-%s" (include "your-chart.appName" .) }}
{{- end }}

{{/*
Create the AppDynamics node name.
*/}}
{{- define "your-chart.appdNodeName" -}}
{{- printf "%s-%s" (include "your-chart.appName" .) .Values.k8sClusterName }}
{{- end }}