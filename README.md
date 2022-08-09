# AWS Backup Terraform module

Terraform module for AWS Backup.

## Managed resources

- AWS Backup Vault
- AWS Backup Plan
- AWS Backup Resources
- IAM Role + inline policies

## Submodules

- [backup-vault](https://github.com/jampp/terraform-aws-backup-module/tree/main/modules/backup-vault)
- [backup-plan](https://github.com/jampp/terraform-aws-backup-module/tree/main/modules/backup-plan)
- [resource-selection](https://github.com/jampp/terraform-aws-backup-module/tree/main/modules/resource-selection)
- [complete](https://github.com/jampp/terraform-aws-backup-module/tree/main/modules/complete)

## Usage

`backup-vault`:

```hcl
module "backup_vault" {
  source = "git::git@github.com:jampp/terraform-aws-backup-module.git//modules/backup-vault?ref=<version>"

  name = "my-backup-vault"

  kms_key = "arn:aws:kms:us-east-1:111111111111:key/fa1d968b-8721-4bdf-82ec-535e27624e80"

  policy_statements = [{
    effect = "Allow"
    actions = [
      "backup:DescribeBackupVault",
      "backup:DeleteBackupVault",
      ...
    ]
    principals = [
      { type = "AWS", identifiers = ["*"] }
    ]
    conditions = [ ... ]
  }]

  tags = {
    Example = "Value"
  }

}
```

`backup-plan`:

```hcl
module "backup_plan" {
  source = "git::git@github.com:jampp/terraform-aws-backup-module.git//modules/backup-plan?ref=<version>"

  name = "my-backup-plan"

  rules = [{
    name                     = "daily"
    vault_name               = "my-vault"
    schedule                 = "cron(0 5 * * ? *)" # 05:00 am (UTC) every day
    enable_continuous_backup = true
    start_window             = 60 # 60 min = 1 hr
    completion_window        = 120 # 120 min = 2 hs
    recovery_point_tags      = {
      Tag = "Value"
    }

    lifecycle = {
      cold_storage_after = 7
      delete_after       = 100
    }

    copy_actions = [{
      destination_vault_arn = "arn:aws:backup:us-east-2:111111111111:backup-vault:example-vault"
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
```

`resource-selection`:

```hcl
module "resources" {
  source = "git::git@github.com:jampp/terraform-aws-backup-module.git//modules/resource-selection?ref=<version>"

  # Default plan id. Will be used if plan_id is not specified in resource selection
  plan_id = "064b4195-335d-43e9-8e7b-d0487bfb55b1"

  resource_selection = {

    "my-bucket" = {
      # Use an existing IAM Role
      iam_role_arn = "arn:aws:iam::111111111111:role/service-role/AWSBackupDefaultServiceRole"
      plan_id      = "f9a56b00-79fd-4d58-817c-c205ef146ab6"
      resources = [
        "arn:aws:s3:::bucket.example.com"
      ]
    }

    "another-bucket" = {
      # Create a new IAM Role
      iam_role = {
        inline_policies = {
          "s3-backup" = {
            file = "files/s3-backup-policy.tpl"
            vars = {
              bucket = "bucket-2.example.com"
            }
          }
          "s3-restore" = {
            file = "files/s3-backup-policy.tpl"
            vars = {
              bucket = "bucket-2.example.com"
            }
          }
        }
      }
      resources = [
        "arn:aws:s3:::bucket-2.example.com"
      ]
    }

    }
  }

}
```

`complete`:

```hcl
module "complete" {
  source = "git::git@github.com:jampp/terraform-aws-backup-module.git//modules/complete?ref=<version>"

  # AWS Backup Vault
  create_vault  = true
  vault_name    = "my-vault"
  vault_kms_key = "arn:aws:kms:us-east-1:111111111111:key/fa1d968b-8721-4bdf-82ec-535e27624e80"
  vault_policy_statements = [{
    effect = "Allow"
    actions = [
      "backup:DescribeBackupVault",
      "backup:DeleteBackupVault",
      ...
    ]
    principals = [
      { type = "AWS", identifiers = ["*"] }
    ]
    conditions = [
      {
        test     = "ForAnyValue:StringEquals"
        variable = "kms:EncryptionContext:service"
        values   = [ ... ]
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
      destination_vault_arn = "arn:aws:backup:us-east-2:111111111111:backup-vault:example-vault"
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
      iam_role_arn = "arn:aws:iam::111111111111:role/service-role/AWSBackupDefaultServiceRole"
      resources = [
        "arn:aws:s3:::bucket.example.com"
      ]
    }

    "resource" = {
      # Use an existing IAM Role
      iam_role_arn = "arn:aws:iam::111111111111:role/service-role/AWSBackupDefaultServiceRole"
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
```

## Examples

- [backup-vault](https://github.com/jampp/terraform-aws-backup-module/tree/main/examples/backup-vault)
- [backup-plan](https://github.com/jampp/terraform-aws-backup-module/tree/main/examples/backup-plan)
- [resource-selection](https://github.com/jampp/terraform-aws-backup-module/tree/main/examples/resource-selection)
- [complete](https://github.com/jampp/terraform-aws-backup-module/tree/main/examples/complete)
