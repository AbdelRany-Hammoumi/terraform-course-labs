output "frontend_url" {
  value = module.frontend.endpoint
}

output "backend_url" {
  value = module.backend.endpoint
}

output "frontend_container" {
  value = module.frontend.container_name
}

output "backend_container" {
  value = module.backend.container_name
}
