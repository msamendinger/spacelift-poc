output "hello_dog_stack1" {
  value = data.terraform_remote_state.stack1.outputs.hello_dog
}

