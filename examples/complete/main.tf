provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_kms_key" "kms_key" {
  key_id = "alias/my-key"
}

module "complete" {
  source = "../../modules/complete"

  # AWS Backup Vault
  create_vault  = true
  vault_name    = "my-vault"
  vault_kms_key = data.aws_kms_key.kms_key.arn
  vault_policy_statements = [{
    effect = "Allow"
    actions = [
      "backup:DescribeBackupVault",
      "backup:DeleteBackupVault",
      "backup:PutBackupVaultAccessPolicy",
      "backup:DeleteBackupVaultAccessPolicy",
      "backup:GetBackupVaultAccessPolicy",
      "backup:StartBackupJob",
      "backup:GetBackupVaultNotifications",
      "backup:PutBackupVaultNotifications"
    ]
    principals = [
      { type = "AWS", identifiers = ["*"] }
    ]
    conditions = [
      {
        test     = "ForAnyValue:StringEquals"
        variable = "kms:EncryptionContext:service"
        values   = ["pi"]
      }
    ]
  }]
  vault_tags = {
    Example = "Value"
  }

  # AWS Backup Plan
  create_plan = true
  plan_name   = "my-plan"
  plan_rules = [{
    name                     = "daily"
    vault_name               = "my-vault"
    schedule                 = "cron(0 5 * * ? *)" # 05:00 am (UTC) every day
    enable_continuous_backup = true
    start_window             = 60  # 60 min = 1 hr
    completion_window        = 120 # 120 min = 2 hs
    recovery_point_tags = {
      Tag = "Value"
    }

    lifecycle = {
      cold_storage_after = 7
      delete_after       = 100
    }

    copy_actions = [{
      destination_vault_arn = "arn:aws:backup:us-east-2:${data.aws_caller_identity.current.account_id}:backup-vault:example-vault"
      lifecycle = {
        cold_storage_after = 7
        delete_after       = 100
      }
    }]
  }]
  plan_advanced_backup_setting = {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
  plan_tags = {
    Example = "Value"
  }

  # AWS Backup Resource Selection
  select_resources = true
  resource_selection = {
    "my-bucket" = {
      # Use an existing IAM Role
      # If not specified, plan_id will default to the plan created in this module
      iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AWSBackupDefaultServiceRole"
      resources = [
        "arn:aws:s3:::bucket.example.com"
      ]
    }

    "resource" = {
      # Use an existing IAM Role
      iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AWSBackupDefaultServiceRole"
      plan_id      = "f9a56b00-79fd-4d58-817c-c205ef146ab6"
      # Select resources using tags
      selection_tags = {
        "Component" = {
          type  = "STRINGEQUALS"
          value = "MyComponent"
        }
        "Backup" = {
          type  = "STRINGEQUALS"
          value = "True"
        }
      }

    }
  }

  # Tags for all resources
  tags = {
    Environment = "Production"
  }

}
