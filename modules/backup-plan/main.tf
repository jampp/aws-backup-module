# AWS Backup Plan
resource "aws_backup_plan" "plan" {
  name = var.name

  dynamic "rule" {
    for_each = toset(var.rules)

    content {
      rule_name                = rule.value.name
      target_vault_name        = rule.value.vault_name
      schedule                 = lookup(rule.value, "schedule", null)
      enable_continuous_backup = lookup(rule.value, "enable_continuous_backup", null)
      start_window             = lookup(rule.value, "start_window", null)
      completion_window        = lookup(rule.value, "completion_window", null)
      recovery_point_tags      = lookup(rule.value, "recovery_point_tags", null)

      dynamic "lifecycle" {
        for_each = toset(lookup(rule.value, "lifecycle", null) != null ? [rule.value.lifecycle] : [])

        content {
          cold_storage_after = lookup(lifecycle.value, "cold_storage_after", null)
          delete_after       = lookup(lifecycle.value, "delete_after", null)
        }
      }

      dynamic "copy_action" {
        for_each = toset(lookup(rule.value, "copy_actions", []))
        content {
          destination_vault_arn = lookup(copy_action.value, "destination_vault_arn", null)
          dynamic "lifecycle" {
            for_each = lookup(copy_action.value, "lifecycle", null) != null ? toset([copy_action.value.lifecycle]) : toset([])

            content {
              cold_storage_after = lookup(lifecycle.value, "cold_storage_after", null)
              delete_after       = lookup(lifecycle.value, "delete_after", null)
            }
          }
        }
      }
    }

  }

  dynamic "advanced_backup_setting" {
    for_each = toset(var.advanced_backup_setting != null ? [var.advanced_backup_setting] : [])

    content {
      backup_options = lookup(advanced_backup_setting.value, "backup_options", {})
      resource_type  = lookup(advanced_backup_setting.value, "resource_type", null)
    }
  }

  tags = var.tags
}
