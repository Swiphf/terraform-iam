resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "policy" {
  name = var.policy_name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      for statement in var.policy_statements : {
        Effect   = statement.effect
        Action   = statement.actions
        Resource = statement.resources
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

output "role_arn" {
  value = aws_iam_role.role.arn
}

output "policy_arn" {
  value = aws_iam_policy.policy.arn
}

# Updating the bucket policy to grant permissions to the IAM role
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = data.aws_s3_bucket.code_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : aws_iam_role.role.arn
      },
      "Action" : "s3:GetObject",
      "Resource" : "${data.aws_s3_bucket.code_bucket.arn}/*"
    }]
  })
}
