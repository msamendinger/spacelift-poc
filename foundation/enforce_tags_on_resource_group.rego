package spacelift

# This example plan policy enforces specific tags are present on your resources
#
# You can read more about plan policies here:
# https://docs.spacelift.io/concepts/policy/terraform-plan-policy

required_tags := {"mbmAppName", "mbmEnvironment"}

deny[sprintf("resource %q does not have all suggested tags (%s)", [resource.address, concat(", ", missing_tags)])] {
	resource := input.terraform.resource_changes[_]
	tags := resource.change.after.tags

	missing_tags := {tag | required_tags[tag]; not tags[tag]}

	count(missing_tags) > 0

	resource.type == "azurerm_resource_group"
}

# Learn more about sampling policy evaluations here:
# https://docs.spacelift.io/concepts/policy#sampling-policy-inputs
# sample { count(deny) == 0 }
sample { true }
