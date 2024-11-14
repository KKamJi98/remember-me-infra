output "id" {
  value       = aws_iam_policy.this.id
  description = "The ID of the policy"
}

output "arn" {
  value       = aws_iam_policy.this.arn
  description = "The ARN of the policy"
}

output "name" {
  value       = aws_iam_policy.this.name
  description = "The name of the policy"
}

output "policy" {
  value       = aws_iam_policy.this.policy
  description = "The policy document"
}