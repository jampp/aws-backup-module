provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

module "resources" {
  source = "../../modules/resource-selection"

  # Default plan id. Will be used if plan_id is not specified in resource selection
  plan_id = "064b4195-335d-43e9-8e7b-d0487bfb55b1"

  resource_selection = {

    "my-bucket" = {
      # Use an existing IAM Role
      iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AWSBackupDefaultServiceRole"
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

    "resource" = {
      # Use an existing IAM Role
      iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AWSBackupDefaultServiceRole"
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

      "another-resource" = {
        iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AWSBackupDefaultServiceRole"
        # Select resources using conditions
        conditions = {
          "ec2:Region" = {
            condition = "STRINGEQUALS"
            value     = "us-east-1"
          }
        }
      }

    }
  }

}
