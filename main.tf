terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "iam" {
  source     = "./modules/iam"
  aws_region = var.aws_region
  role_name  = "LambdaExecutionRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "lambda.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })

  policy_name        = "lambda_policy"
  policy_description = var.policy_description

  policy_statements = [
    {
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["*"]
    },
    {
      effect    = "Allow"
      actions   = ["rds-db:connect"]
      resources = ["*"]
    },
    {
      effect    = "Allow"
      actions   = ["s3:GetObject"]
      resources = ["${data.aws_s3_bucket.code_bucket.arn}/*"]
    },
    {
      effect    = "Allow"
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
      # resources = ["arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:${var.secret_name}"]
    }
  ]
}
