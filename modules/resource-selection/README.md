# Resource selection for AWS Backup

Selects resources for AWS Backup Plan

## Managed resources

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
| [resource_roles](https://github.com/jampp/terraform-aws-iam-module/tree/main/modules/inline-role) | >= 1.0 |

## Resources
| Name | Type |
|------|------|
| [resource_roles](https://github.com/jampp/terraform-aws-iam-module/tree/main/modules/inline-role) | module |
| [aws_backup_selection.resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| plan_id | Default plan id. Will be used if plan_id is not specified in resource selection | `string` | `""` | no |
| resource_selection | Map of selection conditions for AWS Backup plan resources. | `any` | `{}` | no |
| tags | Tags for all resources managed by this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| resources | Object containing the selected resources |
