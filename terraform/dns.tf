#
# Private DNS resources
#
resource "aws_route53_zone" "internal" {
  name = "${var.r53_private_hosted_zone}"

  vpc {
    vpc_id     = "${module.vpc.id}"
    vpc_region = "${var.aws_region}"
  }

  tags {
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

#
# Public DNS resources
#
resource "aws_route53_zone" "external" {
  name = "${var.r53_public_hosted_zone}"
}

resource "aws_route53_record" "bastion" {
  zone_id = "${aws_route53_zone.external.zone_id}"
  name    = "bastion.${var.r53_public_hosted_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${module.vpc.bastion_hostname}"]
}
