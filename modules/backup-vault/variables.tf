variable "name" {
  type        = string
  default     = ""
  description = "Name of the backup vault to create."
}

variable "kms_key" {
  type        = string
  description = ""
  default     = "(optional, default: '') The server-side encryption key that is used to protect your backups."
}

variable "policy_statements" {
  type        = list(any)
  default     = []
  description = "Statements for the AWS Backup Vault policy."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(optional, default: null) Tags for AWS Backup Vault resource"
}
