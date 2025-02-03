
resource "aws_securitylake_data_lake" "main" {
  meta_store_manager_role_arn = aws_iam_role.asl_meta_store_manager.arn

  configuration {
    region = "eu-west-2"

    encryption_configuration {
      kms_key_id = aws_kms_key.asl_s3.id
    }

  }

  depends_on = [aws_iam_service_linked_role.AWSServiceRoleForSecurityLakeResourceManagement]
}

resource "aws_securitylake_aws_log_source" "cloudtrail" {
  source {
    regions     = ["eu-west-2"]
    source_name = "CLOUD_TRAIL_MGMT"
  }

  depends_on = [aws_securitylake_data_lake.main]
}
