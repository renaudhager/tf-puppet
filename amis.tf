#
# Retrieve ami
#
data "aws_ami" "centos7_ami" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["aws-marketplace"]
  }

  filter {
    name  = "architecture"
    values = ["x86_64"]
  }

  name_regex = "^CentOS Linux 7"
  owners = ["679593333241"]
}
