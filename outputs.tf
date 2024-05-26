output "lambda_role_arn" {
  value = module.iam.role_arn
}

output "lambda_policy_arn" {
  value = module.iam.policy_arn
}
