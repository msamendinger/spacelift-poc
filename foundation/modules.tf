resource "spacelift_module" "tags" {
  branch       = "main"
  description  = "Tagging module"
  repository   = "spacelift-poc"
  project_root = "modules/tags"
}

resource "spacelift_module" "meta" {
  branch       = "main"
  description  = "meta module"
  repository   = "spacelift-poc"
  project_root = "modules/meta"
}

