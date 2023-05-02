data "spacelift_current_stack" "this" {}

resource "spacelift_stack" "stack1" {
  name                            = "stack1"
  autodeploy                      = true
  terraform_external_state_access = true
  # Source code.
  repository   = "spacelift-poc"
  branch       = "main"
  project_root = "stack1"
  labels       = ["managed", "depends-on:${data.spacelift_current_stack.this.id}", "feature:add_plan_pr_comment"]
}

resource "spacelift_stack" "stack2" {
  name           = "stack2"
  administrative = true
  autodeploy     = true
  # Source code.
  repository   = "spacelift-poc"
  branch       = "main"
  project_root = "stack2"
  labels       = ["managed", "depends-on:${data.spacelift_current_stack.this.id}", "feature:add_plan_pr_comment"]
}

resource "spacelift_stack" "dev" {
  name         = "azure-dev"
  repository   = "spacelift-poc"
  branch       = "main"
  project_root = "env/dev"
  labels       = ["managed", "depends-on:${data.spacelift_current_stack.this.id}", "feature:add_plan_pr_comment"]
}

resource "spacelift_environment_variable" "arm_client_id" {
  stack_id = "azure-dev"
  name     = "ARM_CLIENT_ID"
  value    = ""
}

resource "spacelift_environment_variable" "arm_secret_id" {
  stack_id = "azure-dev"
  name     = "ARM_SECRET_ID"
  value    = ""
}

resource "spacelift_environment_variable" "arm_subscription_id" {
  stack_id = "azure-dev"
  name     = "ARM_SUBSCRIPTION_ID"
  value    = ""
}

resource "spacelift_environment_variable" "arm_tenant_id" {
  stack_id = "azure-dev"
  name     = "ARM_TENANT_ID"
  value    = ""
}

