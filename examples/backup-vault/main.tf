provider "aws" {
  region = "us-east-1"
}

data "aws_kms_key" "kms_key" {
  key_id = "alias/my-key"
}

module "backup_vault" {
  source = "../../modules/backup-vault"

  name = "my-backup-vault"

  kms_key = data.aws_kms_key.kms_key.arn

  policy_statements = [{
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

  tags = {
    Example = "Value"
  }

}
