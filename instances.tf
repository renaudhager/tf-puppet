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
  tags {
    Name  = "puppetmaster-01"
    Owner = "${var.owner}"
  }
}

#
# Output
#
output "puppetca_fqdn" {
  value = "${var.puppet_ca_hostname}.${var.tld}"
}
