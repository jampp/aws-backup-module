# Backup Plan for AWS Backup

Creates single AWS Backup Plan

## Managed resources

- AWS Backup Plan

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
| [aws_backup_plan.plan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| name | The display name of a backup plan. | `string` | `null` | yes |
| rules | A list of rule objects that specifies a scheduled task that is used to back up a selection of resources. | `list(any)` | `[]` | yes |
| advanced_backup_setting | An object that specifies backup options for each resource type. | `any` | `{}` | no |
| tags | Tags for all resources managed by this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| plan | Object containing `arn`, `id`, `name`, `rules`, `tags`, `tags_all`, `version` |
