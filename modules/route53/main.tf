data "aws_route53_zone" "example" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_acm_certificate" "example" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "example" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.example.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.example.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.example.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.example.id
  ttl             = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [aws_route53_record.example.fqdn]
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.example.id
  name    = var.domain_name

  type = "A"

  alias {
    name                   = var.cdn_domain_name
    zone_id                = var.cdn_hosted_zone_id
    evaluate_target_health = false
  }
}