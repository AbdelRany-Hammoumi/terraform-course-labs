# TODO: Expose module outputs at the root level
# - frontend_url (from module.frontend.endpoint)
output "frontend_url" {
    value = module.frontend.endpoint
}

# - backend_url (from module.backend.endpoint)
output "backend_url" {
    value = module.backend.endpoint
}

# - frontend_container (from module.frontend.container_name)
output "frontend_container" {
    value = module.frontend.container_name
}

# - backend_container (from module.backend.container_name)
output "backend_container" {
    value = module.backend.container_name
}

output "frontend_image_id" {
    value = module.frontend.image_id
}