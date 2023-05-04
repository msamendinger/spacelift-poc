resource "spacelift_module" "tags" {
  name         = "tags"
  branch       = "main"
  description  = "Tagging module"
  repository   = "spacelift-poc"
  project_root = "modules/tags"
}

resource "spacelift_module" "meta" {
  name         = "meta"
  branch       = "main"
  description  = "meta module"
  repository   = "spacelift-poc"
  project_root = "modules/meta"
}

