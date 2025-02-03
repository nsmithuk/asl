
data "aws_caller_identity" "current" {}

resource "aws_kms_key" "asl_s3" {
  description             = "Security Lake Key"
  enable_key_rotation     = true
  deletion_window_in_days = 20
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable Administration"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      },
      {
        "Sid": "Allow use of the key",
        "Effect": "Allow",
        "Principal": {"AWS": aws_iam_role.asl_meta_store_manager.arn},
        "Action": [
          "kms:CreateGrant",
          "kms:DescribeKey",
          "kms:GenerateDataKey"
        ],
        "Resource": "*"
      },
      {
          "Sid": "Allow SLR",
          "Effect": "Allow",
          "Principal": {
              "AWS": aws_iam_service_linked_role.AWSServiceRoleForSecurityLakeResourceManagement.arn
          },
          "Action": [
              "kms:Decrypt",
              "kms:GenerateDataKey*"
          ],
          "Resource": "*",
          "Condition": {
              "StringLike": {
                  "kms:ViaService": "s3.eu-west-2.amazonaws.com",
                  "kms:EncryptionContext:aws:s3:arn": "arn:aws:s3:::aws-security-data-lake-eu-west-2-*"
              }
          }
      }
    ]
  })
}
