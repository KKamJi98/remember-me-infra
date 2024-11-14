output "id" {
  value       = aws_iam_role.this.id
  description = "The ID of the IAM Role"
}

output "arn" {
  value       = aws_iam_role.this.arn
  description = "The ARN of the IAM Role"
}

output "name" {
  value       = aws_iam_role.this.name
  description = "The name of the IAM Role"
}