#
# puppet CA instance
#
resource "aws_instance" "puppetca" {
  ami                         = "${data.aws_ami.centos7_ami.id}"
  instance_type               = "${var.instance_puppetca}"
  subnet_id                   = "${element(split( ",", data.terraform_remote_state.vpc_rs.private_subnet), 0)}"
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.puppet.id}"]
  user_data                   = "${data.template_file.puppetca.rendered}"
  associate_public_ip_address = false
  tags {
    Name  = "${var.puppet_ca_hostname}"
    Owner = "${var.owner}"
  }
}

#
# puppetdb db sql host
#
resource "aws_instance" "puppetdb_pgsql" {
  ami                         = "${data.aws_ami.centos7_ami.id}"
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
  ami                         = "${data.aws_ami.centos7_ami.id}"
  instance_type               = "${var.instance_puppetdb}"
  subnet_id                   = "${element(split( ",", data.terraform_remote_state.vpc_rs.private_subnet), count.index)}"
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.puppetdb.id}"]
  user_data                   = "${element(data.template_file.puppetdb.*.rendered, count.index)}"
  associate_public_ip_address = false
  depends_on                  = ["aws_instance.puppetdb_pgsql"]
  # This does not work :-(
  #count                       = "${length( split( ",", data.terraform_remote_state.vpc_rs.azs ) )}"
  count                       = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
  tags {
    Name  = "puppetdb-0${count.index+1}"
    Owner = "${var.owner}"
  }
}


#
# puppet master instance
#
resource "aws_instance" "puppetmaster" {
  ami = "${data.aws_ami.centos7_ami.id}"
  instance_type               = "${var.instance_puppetmaster}"
  subnet_id                   = "${element(split( ",", data.terraform_remote_state.vpc_rs.private_subnet), count.index)}"
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.puppet.id}"]
  user_data                   = "${element(data.template_file.puppetmaster.*.rendered, count.index)}"
  associate_public_ip_address = false
  depends_on                  = ["aws_instance.puppetdb"]
  # This does not work :-(
  #count                       = "${length( split( ",", data.terraform_remote_state.vpc_rs.azs ) )}"
  count                       = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
  tags {
    Name  = "puppetmaster-0${count.index+1}"
    Owner = "${var.owner}"
  }
}

#
# Nginx instances
#
resource "aws_instance" "nginx" {
  ami = "${data.aws_ami.centos7_ami.id}"
  instance_type               = "${var.instance_nginx}"
  subnet_id                   = "${element(split( ",", data.terraform_remote_state.vpc_rs.private_subnet), count.index)}"
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.nginx.id}"]
  user_data                   = "${element(data.template_file.nginx.*.rendered, count.index)}"
  associate_public_ip_address = false
  depends_on                  = ["aws_instance.puppetdb"]
  # This does not work :-(
  #count                       = "${length( split( ",", data.terraform_remote_state.vpc_rs.azs ) )}"
  count                       = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
  tags {
    Name  = "nginx-0${count.index+1}"
    Owner = "${var.owner}"
  }
}


#
# Output
#
output "puppetca_fqdn" {
  value = "${var.puppet_ca_hostname}.${var.tld}"
}

output "puppetca_ip" {
  value = "${aws_instance.puppetca.private_ip}"
}

output "puppetdb_fqdn" {
  value = "puppetdb-db-01.${var.tld}"
}
output "puppetdb_ip" {
  value = "${aws_instance.puppetdb.0.private_ip}"
}

output "puppetdb-pgsql_fqdn" {
  value = "puppetdb-pgsql-01.${var.tld}"
}

output "puppetdb-pgsql_ip" {
  value = "${aws_instance.puppetdb_pgsql.private_ip}"
}
