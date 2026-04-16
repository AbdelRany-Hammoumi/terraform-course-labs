# Outputs for lab1 resources

output "hello_file_path" {
  description = "Absolute path of the hello.txt file managed by Terraform"
  value       = local_file.hello.filename
}

output "app_config_path" {
  description = "Absolute path of the app-config.json file managed by Terraform"
  value       = local_file.app_config.filename
}
