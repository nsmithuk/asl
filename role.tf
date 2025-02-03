
resource "aws_iam_role" "asl_meta_store_manager" {
  name = "asl_meta_store_manager"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "asl_meta_store_manager" {
  role       = aws_iam_role.asl_meta_store_manager.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSecurityLakeMetastoreManager"
}


resource "aws_iam_service_linked_role" "AWSServiceRoleForSecurityLakeResourceManagement" {
  aws_service_name = "resource-management.securitylake.amazonaws.com"
}
