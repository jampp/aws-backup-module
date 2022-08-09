provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

module "backup_plan" {
  source = "../../modules/backup-plan"

  name = "my-backup-plan"

  rules = [{
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

  advanced_backup_setting = {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }

  tags = {
    Example = "Value"
  }

}
