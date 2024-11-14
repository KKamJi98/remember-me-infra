output "attached_role_name" {
  description = "The name of the IAM role to which the policy is attached"
  value       = aws_iam_role_policy_attachment.this.role
}

output "attached_policy_arn" {
  description = "The ARN of the attached IAM policy"
  value       = aws_iam_role_policy_attachment.this.policy_arn
}
