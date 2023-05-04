resource "spacelift_policy" "enforce_tags" {
  name = "Enforce tags based on tagging requirements"
  body = file("./enforce_tags_on_resource_group.rego")
  type = "PLAN"
}

resource "spacelift_policy_attachment" "enforce_tags" {
  policy_id = spacelift_policy.enforce_tags.id
  stack_id  = spacelift_stack.dev.id
}
