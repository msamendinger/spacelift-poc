data "spacelift_current_stack" "this" {}

resource "spacelift_stack" "stack1" {
  name                            = "stack1"
  repository                      = "spacelift-poc"
  autodeploy                      = true
  terraform_external_state_access = true
  # Source code.
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
  name                            = "azure-dev"
  repository                      = "spacelift-poc"
  autodeploy                      = true
  terraform_external_state_access = true
  branch                          = "main"
  project_root                    = "env/dev"
  labels                          = ["managed", "depends-on:${data.spacelift_current_stack.this.id}", "feature:add_plan_pr_comment"]
  runner_image                    = "public.ecr.aws/spacelift/runner-terraform:azure-future"
  enable_local_preview            = true
  before_plan                     = ["terraform fmt -check", "terraform validate"]
}

