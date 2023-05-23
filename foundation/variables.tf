variable "process_exit_behavior" {
  type        = string
  description = "The behavior to use when the Spacelift process exits"
  default     = "Reboot"
  validation {
    condition     = can(regex("^(Reboot|Shutdown|None)$", var.process_exit_behavior))
    error_message = "The process_exit_behavior value must be one of: [Reboot, Shutdown, None]."
  }
}
