# Backup Vault for AWS Backup

Creates single AWS Backup Vault

## Managed resources

- AWS Backup Vault

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

No modules.

## Resources
| Name | Type |
|------|------|
| [aws_iam_policy_document.policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_backup_vault.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| name | Name of the backup vault to create. | `string` | `""` | no |
| kms_key | The server-side encryption key that is used to protect your backups. | string | `""` | no |
| policy_statements | Statements for the AWS Backup Vault policy. | `list(any)` | `[]` | no |
| tags | Tags for all resources managed by this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vault | Object containing `arn`, `id`, `kms_key_arn`, `name`, `recovery_points`, `tags`, `tags_all` |
