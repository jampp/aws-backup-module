# Resource selection for AWS Backup

Selects resources for AWS Backup Plan

## Managed resources

- AWS Backup Vault
- AWS Backup Plan
- IAM Role + inline policies
- AWS Backup Selection

## Requirements

| Name | Version |
|------|---------|
| [terraform](#requirement\_terraform) | >= 1.0.0 |
| [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Version |
|------|---------|
| [backup_vault](https://github.com/jampp/terraform-aws-backup-module/tree/main/modules/backup-vault) | >= 1.0 |
| [backup_plan](https://github.com/jampp/terraform-aws-backup-module/tree/main/modules/backup-plan) | >= 1.0 |
| [resource_selection](https://github.com/jampp/terraform-aws-backup-module/tree/main/modules/resource-selection) | >= 1.0 |

## Resources

No resources.

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| create_vault | Controls if AWS Backup Vault should be created. | `bool` | `false` | no |
| vault_name | Name of the backup vault to create. | `string` | `""` | no |
| vault_kms_key | The server-side encryption key that is used to protect your backups. | string | `""` | no |
| vault_policy_statements | Statements for the AWS Backup Vault policy. | `list(any)` | `[]` | no |
| vault_tags | Tags for all resources managed by the `backup-vault` module | `map(string)` | `{}` | no |
| create_plan | Controls if AWS Backup Plan should be created. | `bool` | `false` | no |
| plan_name | The display name of a backup plan. | `string` | `null` | yes |
| plan_rules | A list of rule objects that specifies a scheduled task that is used to back up a selection of resources. | `list(any)` | `[]` | yes |
| plan_advanced_backup_setting | An object that specifies backup options for each resource type. | `any` | `{}` | no |
| plan_tags | Tags for all resources managed by the `backup-plan` module | `map(string)` | `{}` | no |
| select_resources | If select resources or not. | `bool` | `false` | no |
| resource_selection | Map of selection conditions for AWS Backup plan resources. | `any` | `{}` | no |
| resource_tags | Tags for all resources managed by the `resource-selection` module | `map(string)` | `{}` | no |
| tags | Tags for all resources managed by this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vault | Object containing `arn`, `id`, `kms_key_arn`, `name`, `recovery_points`, `tags`, `tags_all` |
| plan | Object containing `arn`, `id`, `name`, `rules`, `tags`, `tags_all`, `version` |
| resources | Object containing the selected resources |
