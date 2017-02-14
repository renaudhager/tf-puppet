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
    environment           = "${var.puppet_bootstrap_env}"
  }
}

#
# Templates for puppetmaster
#
data "template_file" "puppetmaster" {
  template = "${file("cloudinit/puppetmaster.yml")}"
  count    = "${length( split( ",", lookup( var.azs, var.region ) ) )}"

  vars {
    hostname               = "puppetmaster-0${count.index+1}"
    puppet_agent_version   = "${var.puppet_agent_version}"
    puppet_server_hostname = "${var.puppet_ca_hostname}"
    tld                    = "${var.tld}"
    environment            = "${var.puppet_bootstrap_env}"
  }
}

#
# Templates for puppetdb pgsql host
#
data "template_file" "puppetdb_pgsql" {
  template = "${file("cloudinit/default.yml")}"

  vars {
    hostname               = "puppetdb-pgsql-01"
    puppet_agent_version   = "${var.puppet_agent_version}"
    puppet_server_hostname = "${var.puppet_ca_hostname}"
    tld                    = "${var.tld}"
    environment            = "${var.puppet_bootstrap_env}"
  }
}

#
# Templates for puppetdb host
#
data "template_file" "puppetdb" {
  template = "${file("cloudinit/default.yml")}"
  count    = "${length( split( ",", lookup( var.azs, var.region ) ) )}"

  vars {
    hostname               = "puppetdb-0${count.index+1}"
    puppet_agent_version   = "${var.puppet_agent_version}"
    puppet_server_hostname = "${var.puppet_ca_hostname}"
    tld                    = "${var.tld}"
    environment            = "${var.puppet_bootstrap_env}"
  }
}

#
# Templates for nginx host
#
data "template_file" "nginx" {
  template = "${file("cloudinit/default.yml")}"
  count    = "${length( split( ",", lookup( var.azs, var.region ) ) )}"

  vars {
    hostname               = "nginx-0${count.index+1}"
    puppet_agent_version   = "${var.puppet_agent_version}"
    puppet_server_hostname = "${var.puppet_ca_hostname}"
    tld                    = "${var.tld}"
    environment            = "${var.puppet_bootstrap_env}"
  }
}
