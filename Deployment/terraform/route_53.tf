#create hosted zone
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name

  tags = {
    "Environment" = "dev"
  }
}

#create record
resource "aws_route53_record" "myapp1" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name = var.myapp1_site_domain
  type = "A"
}

resource "aws_route53_record" "myapp2" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name = var.myapp2_site_domain
  type = "A"
}

resource "aws_route53_record" "monitoring" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name = var.monitoring_site_domain
  type = "A"
}
