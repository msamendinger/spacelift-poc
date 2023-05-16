resource "spacelift_context" "azure-env" {
  description = "Azure environment needed to deploy resources"
  name        = "azure-env"
}

resource "spacelift_context_attachment" "azure-env" {
  context_id = spacelift_context.azure-env.id
  stack_id   = spacelift_stack.dev.id
}

resource "spacelift_context_attachment" "foundation" {
  context_id = spacelift_context.azure-env.id
  stack_id   = data.spacelift_current_stack.this.id
}

