{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3BucketRestorePermissions",
            "Action": [
                "s3:CreateBucket",
                "s3:ListBucketVersions",
                "s3:ListBucket",
                "s3:GetBucketVersioning",
                "s3:GetBucketLocation",
                "s3:PutBucketVersioning"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${bucket}"
            ]
        },
        {
            "Sid": "S3ObjectRestorePermissions",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:DeleteObject",
                "s3:PutObjectVersionAcl",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectTagging",
                "s3:PutObjectTagging",
                "s3:GetObjectAcl",
                "s3:PutObjectAcl",
                "s3:PutObject",
                "s3:ListMultipartUploadParts"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${bucket}/*"
            ]
        },
        {
            "Sid": "S3KMSPermissions",
            "Action": [
                "kms:Decrypt",
                "kms:DescribeKey",
                "kms:GenerateDataKey"
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
