variable "name" {
  type        = string
  description = "The display name of a backup plan."
}

variable "rules" {
  type        = list(any)
  default     = []
  description = "(optional, default: []) A list of rule objects that specifies a scheduled task that is used to back up a selection of resources."
}

variable "advanced_backup_setting" {
  type        = any
  default     = null
  description = "(optional, default: {}) Specifies the backup option for a selected resource."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(optional, default: null) Tags for AWS Backup Plan resource"
}
