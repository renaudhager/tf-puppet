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
  name    = "puppetmaster-0${count.index+1}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.puppetmaster.*.private_ip, count.index)}"]
  count   = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
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
  name    = "puppetdb-0${count.index+1}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.puppetdb.*.private_ip, count.index)}"]
  count   = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
}

// resource "aws_route53_record" "puppetdb-04" {
//   zone_id = "${data.terraform_remote_state.vpc_rs.default_route53_zone}"
//   name    = "puppetdb-04"
//   type    = "A"
//   ttl     = "300"
//   records = ["${aws_instance.puppetdb-04.private_ip}"]
// }

resource "aws_route53_record" "nginx" {
  zone_id = "${data.terraform_remote_state.vpc_rs.default_route53_zone}"
  name    = "nginx-0${count.index+1}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.nginx.*.private_ip, count.index)}"]
  count   = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
}
