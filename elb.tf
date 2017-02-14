#
# ELB  Definitions
#

resource "aws_elb" "puppet_elb" {
  name       = "${var.ownerv2}-puppet-elb"
  subnets    = ["${split( ",", data.terraform_remote_state.vpc_rs.public_subnet)}"]
  depends_on = ["aws_instance.nginx"]

  listener {
    instance_port      = 80
    instance_protocol  = "tcp"
    lb_port            = 80
    lb_protocol        = "tcp"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 10
  }

  instances                   = ["${aws_instance.nginx.*.id}"]
  security_groups             = ["${aws_security_group.puppet_elb.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

    tags {
      Name  = "core_elb"
      owner = "${var.owner}"
    }

}

#
# Output
#

output "puppet_elb"{
  value = "${aws_elb.puppet_elb.dns_name}"
}
