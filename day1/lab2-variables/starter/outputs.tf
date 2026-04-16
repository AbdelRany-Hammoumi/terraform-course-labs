# 7 — Outputs

output "config_filename" {
  description = "Chemin vers le fichier JSON généré"
  value       = local_file.config.filename
}

output "config_content" {
  description = "Contenu JSON décodé du fichier généré"
  value       = jsondecode(local_file.config.content)
}

output "project_summary" {
  description = "Résumé combinant le nom du projet et l'environnement"
  value       = "${var.project_name} (${var.environment})"
}

output "read_back_content" {
  description = "Contenu lu via le data source (doit être identique à config_content)"
  value       = jsondecode(data.local_file.read_config.content)
}
