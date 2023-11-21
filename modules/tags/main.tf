locals {
  tags = {
    mbmAppName               = var.mbmAppName
    mbmCloudSecResponsible   = var.mbmCloudSecResponsible
    mbmEnvironment           = lower(var.mbmEnvironment)
    mbmInformationOwner      = var.mbmInformationOwner
    mbmIso                   = var.mbmIso
    mbmPlanningItId          = var.mbmPlanningItId
    mbmProductiveData        = lower(var.mbmProductiveData)
    mbmTechnicalOwner        = var.mbmTechnicalOwner
    mbmTechnicalOwnerContact = var.mbmTechnicalOwnerContact
    mbmConfidentiality       = lower(var.mbmConfidentiality)
    mbmIntegrity             = lower(var.mbmIntegrity)
    mbmAvailability          = lower(var.mbmAvailability)
    mbmContinuityCritical    = lower(var.mbmContinuityCritical)
    mbmPersonalData          = lower(var.mbmPersonalData)
    mbmTagsVersion           = "v0.2.2"
    # We want to know what version of the azure-gb4-tags version was being used
    # to tag the resources. mbmTagsVersion makes this possible by looking at
    # the resource itself.
    # We can use this to get an overview on the usage of our versions.
  }
}

