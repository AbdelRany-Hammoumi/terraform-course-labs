data "terraform_remote_state" "lab3" {
  backend = "local"
  config = {
    path = "../starter/state/terraform.tfstate"
  }
}

resource "local_file" "test" {
  filename = "${path.module}/test.txt"
  content = data.terraform_remote_state.lab3.outputs.app_config_path
}