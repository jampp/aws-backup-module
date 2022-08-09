output "vault" {
  value = length(module.backup_vault) > 0 ? module.backup_vault.0.vault : null
}

output "plan" {
  value = length(module.backup_plan) > 0 ? module.backup_plan.0.plan : null
}

output "resources" {
  value = length(module.resource_selection) > 0 ? module.resource_selection.0.resources : null
}
