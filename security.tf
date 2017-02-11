###############################
# Security groups Definitions #
###############################

# Security group for access to Bastion
resource "aws_security_group" "puppet" {
  name        = "${var.owner}_puppet"
  description = "Allow all inbound traffic to puppet"
  vpc_id      = "${data.terraform_remote_state.vpc_rs.vpc}"

  # Allow SSH remote acces
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${data.terraform_remote_state.bastion_rs.sg_bastion}"]
  }

  # Allow puppet traffic
  ingress {
    from_port   = 8140
    to_port     = 8140
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  # Allow ICMP traffic
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${data.terraform_remote_state.vpc_rs.vpc_cidr_block}"]
  }

  # Allow outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name  = "${var.owner}_puppet"
    owner = "${var.owner}"
  }
}


#
# Outputs
#

output "sg_puppet" {
  value = "${aws_security_group.puppet.id}"
}
