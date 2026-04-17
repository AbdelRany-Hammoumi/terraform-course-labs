# TODO: Add outputs after completing the core lab
# These are needed if you attempt the "Going Further" exercise
# with terraform_remote_state.
output "app_config_path" {
  value = local_file.app_config.filename
}