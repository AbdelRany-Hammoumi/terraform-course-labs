output "frontend_url" {
  description = "Frontend application URL"
  value       = module.frontend.endpoint
}

output "backend_url" {
  description = "Backend application URL"
  value       = module.backend.endpoint
}

output "frontend_container" {
  description = "Frontend container name"
  value       = module.frontend.container_name
}

output "backend_container" {
  description = "Backend container name"
  value       = module.backend.container_name
}

output "frontend_image_id" {
  value = module.frontend.image_id
}