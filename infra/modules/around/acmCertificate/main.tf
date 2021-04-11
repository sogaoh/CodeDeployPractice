################################
# ACM Certificate
# @see https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-validate-dns.html
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
################################
resource "aws_acm_certificate" "acm_certificate_module" {
  domain_name = "${var.certificate_subdomain}.${var.certificate_domain}"
  validation_method = "DNS"

  tags = {
    Name = "certificate_${var.certificate_subdomain == "*" ? "wc" : var.certificate_subdomain}_${var.certificate_domain}"
    Env = var.tags_env
  }

  lifecycle {
    create_before_destroy = true
  }
}
