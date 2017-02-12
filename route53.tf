#
# ROUTE 53
#
resource "aws_route53_record" "puppetca" {
  zone_id = "${data.terraform_remote_state.vpc_rs.default_route53_zone}"
  name    = "puppetca-01"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.puppetca.*.private_ip}"]
}

resource "aws_route53_record" "puppetmaster" {
  zone_id = "${data.terraform_remote_state.vpc_rs.default_route53_zone}"
  name    = "puppetmaster-01"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.puppetmaster.*.private_ip}"]
}

resource "aws_route53_record" "puppetdb_pgsql" {
  zone_id = "${data.terraform_remote_state.vpc_rs.default_route53_zone}"
  name    = "puppetdb-pgsql-01"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.puppetdb_pgsql.*.private_ip}"]
}

resource "aws_route53_record" "puppetdb" {
  zone_id = "${data.terraform_remote_state.vpc_rs.default_route53_zone}"
  name    = "puppetdb-01"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.puppetdb.*.private_ip}"]
}

#
# output
#
output "puppetca_dns_record" {
  value = "${aws_route53_record.puppetca.records}"
}

output "puppetdb_pgsql_record" {
  value = "${aws_route53_record.puppetdb_pgsql.records}"
}

output "puppetdb_record" {
  value = "${aws_route53_record.puppetdb.records}"
}
