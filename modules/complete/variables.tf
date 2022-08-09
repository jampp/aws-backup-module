variable "create_vault" {
  type        = bool
  default     = false
  description = "(optional, default: false) Controls if AWS Backup Vault should be created."
}

variable "vault_name" {
  type        = string
  default     = ""
  description = "Name of the backup vault to create."
}

variable "vault_kms_key" {
  type        = string
  description = ""
  default     = "(optional, default: '') The server-side encryption key that is used to protect your backups."
}

variable "vault_tags" {
  type        = map(string)
  default     = {}
  description = "(optional, default: null) Tags for AWS Backup Vault resource"
}

variable "vault_policy_statements" {
  type        = list(any)
  default     = []
  description = "Statements for the AWS Backup Vault policy."
}

variable "create_plan" {
  type        = bool
  default     = false
  description = "(optional, default: false) Controls if AWS Backup Plan should be created."
}

variable "plan_name" {
  type        = string
  default     = ""
  description = "The display name of a backup plan"
}

variable "plan_rules" {
  type        = list(any)
  default     = []
  description = "(optional, default: []) A list of rule objects that specifies a scheduled task that is used to back up a selection of resources."
}

variable "plan_advanced_backup_setting" {
  type        = any
  default     = null
  description = "(optional, default: {}) Specifies the backup option for a selected resource."
}

variable "plan_tags" {
  type        = map(string)
  default     = {}
  description = "(optional, default: null) Tags for AWS Backup Plan resource"
}

variable "select_resources" {
  type        = bool
  default     = false
  description = "(optional, default: false) Controls if resources should be selected."
}

variable "resource_selection" {
  type        = any
  default     = {}
  description = "(optional, default: {}) Map of selection conditions for AWS Backup plan resources."
}

variable "resource_tags" {
  type        = map(string)
  default     = {}
  description = "(optional, default: null) Tags for AWS Backup sesource selection"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(optional, default: null) Tags for all resources managed by this module"
}
