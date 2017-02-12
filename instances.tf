#
# puppet CA instance
#
resource "aws_instance" "puppetca" {
  ami = "${data.aws_ami.centos7_ami.id}"
  instance_type               = "${var.instance_puppetca}"
  subnet_id                   = "${element(split( ",", data.terraform_remote_state.vpc_rs.private_subnet), 0)}"
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.puppet.id}"]
  user_data                   = "${data.template_file.puppetca.rendered}"
  associate_public_ip_address = false
  lifecycle {
    ignore_changes = ["user_data"]
  }
  tags {
    Name  = "${var.puppet_ca_hostname}"
    Owner = "${var.owner}"
  }
}

#
# puppet master instance
#
resource "aws_instance" "puppetmaster" {
  ami = "${data.aws_ami.centos7_ami.id}"
  instance_type               = "${var.instance_puppetmaster}"
  subnet_id                   = "${element(split( ",", data.terraform_remote_state.vpc_rs.private_subnet), 1)}"
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.puppet.id}"]
  user_data                   = "${data.template_file.puppetmaster.rendered}"
  associate_public_ip_address = false
  depends_on                  = ["aws_instance.puppetca"]
  tags {
    Name  = "puppetmaster-01"
    Owner = "${var.owner}"
  }
}

#
# puppetdb db host
#
resource "aws_instance" "puppetdb_pgsql" {
  ami = "${data.aws_ami.centos7_ami.id}"
  instance_type               = "${var.instance_pgsql}"
  subnet_id                   = "${element(split( ",", data.terraform_remote_state.vpc_rs.private_subnet), 1)}"
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.puppetdb_pgsql.id}"]
  user_data                   = "${data.template_file.puppetdb_pgsql.rendered}"
  associate_public_ip_address = false
  depends_on                  = ["aws_instance.puppetca"]
  tags {
    Name  = "puppetdb-pgsql-01"
    Owner = "${var.owner}"
  }
}

#
# puppetdb db host
#
resource "aws_instance" "puppetdb" {
  ami = "${data.aws_ami.centos7_ami.id}"
  instance_type               = "${var.instance_pgsql}"
  subnet_id                   = "${element(split( ",", data.terraform_remote_state.vpc_rs.private_subnet), 1)}"
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.puppetdb.id}"]
  user_data                   = "${data.template_file.puppetdb.rendered}"
  associate_public_ip_address = false
  depends_on                  = ["aws_instance.puppetdb_pgsql"]
  tags {
    Name  = "puppetdb-db-01"
    Owner = "${var.owner}"
  }
}

#
# Output
#
output "puppetca_fqdn" {
  value = "${var.puppet_ca_hostname}.${var.tld}"
}

output "puppetdb_fqdn" {
  value = "puppetdb-db-01.${var.tld}"
}

output "puppetdb-pgsql_fqdn" {
  value = "puppetdb-pgsql-01.${var.tld}"
}
