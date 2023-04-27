terraform {
  required_version = "~> 1.4.0"
}

data "terraform_remote_state" "stack1" {
  backend = "remote"

  config = {
    hostname     = "spacelift.io"
    organization = "msamendinger"

    workspaces = {
      name = "spacelift-poc-stack1"
    }
  }
}

output "hello_dog_stack1" {
  value = data.terraform_remote_state.stack1.outputs.hello_dog
}

