resource "spacelift_stack" "stack1" {
  name                            = "stack1"
  autodeploy                      = true
  terraform_external_state_access = true
  # Source code.
  repository   = "spacelift-poc"
  branch       = "master"
  project_root = "stack1"
}

resource "spacelift_stack" "stack2" {
  name           = "stack2"
  administrative = true
  autodeploy     = true
  # Source code.
  repository   = "spacelift-poc"
  branch       = "master"
  project_root = "stack2"
}

