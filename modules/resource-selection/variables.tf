variable "plan_id" {
  type        = string
  default     = ""
  description = "(optional, default: '') Default plan id. Will be used if plan_id is not specified in resource selection"
}

variable "resource_selection" {
  type        = any
  default     = {}
  description = "(optional, default: {}) Map of selection conditions for AWS Backup plan resources."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(optional, default: null) Tags for all resources in this module."
}
