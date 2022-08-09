# AWS Backup Vault
resource "aws_backup_vault" "vault" {
  name        = var.name
  kms_key_arn = var.kms_key
  tags        = var.tags
}

data "aws_iam_policy_document" "policy_document" {
  dynamic "statement" {
    for_each = var.policy_statements
    content {
      effect  = statement.value.effect
      actions = statement.value.actions

      dynamic "principals" {
        for_each = statement.value.principals
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.conditions
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }

      resources = [aws_backup_vault.vault.arn]
    }
  }

  depends_on = [
    aws_backup_vault.vault
  ]
}

resource "aws_backup_vault_policy" "policy" {
  backup_vault_name = aws_backup_vault.vault.name
  policy            = data.aws_iam_policy_document.policy_document.json

  depends_on = [
    data.aws_iam_policy_document.policy_document
  ]
}
