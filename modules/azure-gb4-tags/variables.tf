variable "mbmAppName" {
  type = string
}

variable "mbmCloudSecResponsible" {
  type = string
}

variable "mbmEnvironment" {
  type = string
}

variable "mbmInformationOwner" {
  type = string
}

variable "mbmIso" {
  type = string
}

variable "mbmPlanningItId" {
  type = string
}

variable "mbmProductiveData" {
  type = string
}

variable "mbmTechnicalOwner" {
  type = string
}

variable "mbmTechnicalOwnerContact" {
  type = string
}

variable "mbmConfidentiality" {
  type = string
}

variable "mbmIntegrity" {
  type = string
}

variable "mbmAvailability" {
  type = string
}

variable "mbmContinuityCritical" {
  type = string
}

variable "mbmPersonalData" {
  type = string
}

variable "tags" {
  description = <<EOT
  If you already have tags defined in your terraform code, you can pass them
  as a map to the module with the help of this variable. Your tags will then
  get merged with the tags provided by the module.
  Thus you only have to implement the modules tags on the resources/resource group 
  EOT
  type        = map(string)
  default     = {}
}

