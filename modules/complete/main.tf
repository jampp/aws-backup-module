# AWS Backup Vault
module "backup_vault" {
  source = "../backup-vault"
  count  = var.create_vault ? 1 : 0

  name              = var.vault_name
  kms_key           = var.vault_kms_key
  tags              = merge(var.tags, var.vault_tags)
  policy_statements = var.vault_policy_statements
}

# AWS Backup Plan
module "backup_plan" {
  source = "../backup-plan"
  count  = var.create_plan ? 1 : 0

  name                    = var.plan_name
  rules                   = var.plan_rules
  advanced_backup_setting = var.plan_advanced_backup_setting
  tags                    = merge(var.tags, var.plan_tags)
}

# Resource selection
module "resource_selection" {
  source = "../resource-selection"
  count  = var.select_resources ? 1 : 0

  plan_id            = length(module.backup_plan) > 0 ? module.backup_plan.0.plan.id : null
  resource_selection = var.resource_selection

  tags = merge(var.tags, var.resource_tags)
}
