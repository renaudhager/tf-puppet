#
# Templates for puppetca
#
data "template_file" "puppetca" {
  template = "${file("cloudinit/puppetca.yml")}"

  vars {
    hostname              = "${var.puppet_ca_hostname}"
    puppet_agent_version  = "${var.puppet_agent_version}"
    puppet_server_version = "${var.puppet_server_version}"
    tld                   = "${var.tld}"
  }
}

#
# Templates for puppetmaster
#
data "template_file" "puppetmaster" {
  template = "${file("cloudinit/default.yml")}"

  vars {
    hostname               = "puppetmaster-01"
    puppet_agent_version   = "${var.puppet_agent_version}"
    puppet_server_hostname = "${var.puppet_ca_hostname}"
    tld                    = "${var.tld}"
  }
}
