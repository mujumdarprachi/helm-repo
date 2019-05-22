{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "gateway-domain" -}}
{{- $value := default "" .Values.global.gateway.domain -}}
{{- tpl (printf "%s" $value) . -}}
{{- end -}}

{{- define "gateway-host" -}}
{{- $value := default (include "gateway-domain" .) .Values.global.gateway.host -}}
{{- tpl (printf "%s" $value) . -}}
{{- end -}}

{{- define "keycloak-host" -}}
{{- $value := default (include "gateway-host" .) .Values.global.keycloak.host -}}
{{- tpl (printf "%s" $value) . -}}
{{- end -}}


{{- define "gateway-proto" -}}
{{- $http := toString .Values.global.gateway.http -}}
{{- if eq $http "false" }}https{{else}}http{{ end -}}
{{- end -}}

{{/*
Create a keycloak url template
*/}}
{{- define "keycloak-url" -}}
	{{- $common := dict "Values" .Values.common -}} 
	{{- $noCommon := omit .Values "common" -}} 
	{{- $overrides := dict "Values" $noCommon -}} 
	{{- $noValues := omit . "Values" -}} 
	{{- with merge $noValues $overrides $common -}}
		{{- $proto := include "gateway-proto" . -}}
		{{- $host := include "keycloak-host" . -}}
		{{- $path := .Values.global.keycloak.path -}}
		{{- $url := printf "%s://%s%s" $proto $host $path -}}
		{{- $keycloakUrl := default $url .Values.global.keycloak.url -}}
		{{- tpl (printf "%s" $keycloakUrl ) . -}}
	{{- end -}}
{{- end -}}
