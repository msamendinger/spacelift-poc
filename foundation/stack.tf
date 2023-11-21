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
  worker_pool_id                  = "01H152979XDP6X5J8ZN034V661"
  autodeploy                      = true
  terraform_external_state_access = true
  branch                          = "main"
  project_root                    = "env/dev"
  labels                          = ["managed", "depends-on:${data.spacelift_current_stack.this.id}", "feature:add_plan_pr_comment"]
  runner_image                    = "public.ecr.aws/spacelift/runner-terraform:azure-latest"
  enable_local_preview            = true
  before_plan                     = ["terraform fmt -check", "terraform validate"]
}

resource "spacelift_drift_detection" "dev" {
  stack_id  = spacelift_stack.dev.id
  schedule  = ["*/15 * * * *"] # Every 15 minutes
  reconcile = true
}

resource "spacelift_stack" "datadog" {
  github_enterprise {
    namespace = "mbm" # The GitHub organization the repository belongs to
  }
  name                            = "datadog"
  repository                      = "datadog"
  worker_pool_id                  = "01H152979XDP6X5J8ZN034V661"
  autodeploy                      = true
  terraform_external_state_access = true
  branch                          = "main"
  project_root                    = "env/prod"
  labels                          = ["managed", "depends-on:${data.spacelift_current_stack.this.id}", "feature:add_plan_pr_comment"]
  runner_image                    = "public.ecr.aws/spacelift/runner-terraform:latest"
  enable_local_preview            = true
  before_plan                     = ["terraform fmt -check", "terraform validate"]
}

