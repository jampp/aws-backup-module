{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3BucketBackupPermissions",
            "Action": [
                "s3:GetInventoryConfiguration",
                "s3:PutInventoryConfiguration",
                "s3:ListBucketVersions",
                "s3:ListBucket",
                "s3:GetBucketVersioning",
                "s3:GetBucketNotification",
                "s3:PutBucketNotification",
                "s3:GetBucketLocation",
                "s3:GetBucketTagging"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${bucket}"
            ]
        },
        {
            "Sid": "S3ObjectBackupPermissions",
            "Action": [
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:GetObjectVersionTagging",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectTagging",
                "s3:GetObjectVersion"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${bucket}/*"
            ]
        },
        {
            "Sid": "S3GlobalPermissions",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "KMSBackupPermissions",
            "Action": [
                "kms:Decrypt",
                "kms:DescribeKey"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "kms:ViaService": "s3.*.amazonaws.com"
                }
            }
        }
    ]
}
