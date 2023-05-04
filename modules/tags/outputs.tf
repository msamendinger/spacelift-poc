output "tags" {
  description = "mAzure required tags"
  value = merge(
    local.tags,
    var.tags
  )
}

