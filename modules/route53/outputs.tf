output "acm_arn" {
  value = aws_acm_certificate.example.arn
}

output "route53_alias" {
  value = aws_route53_record.this.alias
}

output "route53_name" {
  value = aws_route53_record.this.name
}