################################
# ACM Certificate
################################
output "out_acm_certificate_arn" {
  value = aws_acm_certificate.acm_certificate_module.arn
}
