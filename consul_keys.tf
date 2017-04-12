#
# Consul key for signing in Puppet
#
resource "consul_keys" "puppetca_signing" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"

    # Set signing key
    key {
        path   = "${data.terraform_remote_state.vpc_rs.vdc}/signed/${var.puppet_ca_hostname}.${var.tld}"
        value  = "true"
        delete = true
    }
}

resource "consul_keys" "puppetdb_pgsql_signing" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"

    # Set signing key
    key {
        path   = "${data.terraform_remote_state.vpc_rs.vdc}/signed/puppetdb-pgsql-01.${var.tld}"
        value  = "true"
        delete = true
    }
}

resource "consul_keys" "puppetdb_signing" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    count      = "${length( split( ",", lookup( var.azs, var.region ) ) )}"

    key {
        path = "${data.terraform_remote_state.vpc_rs.vdc}/signed/puppetdb-0${count.index+1}.${var.tld}"
        value = "true"
        delete = true
    }
}

resource "consul_keys" "puppetmaster_signing" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    count      = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
    # Set signing key
    key {
        path = "${data.terraform_remote_state.vpc_rs.vdc}/signed/puppetmaster-0${count.index+1}.${var.tld}"
        value = "true"
        delete = true
    }
}

resource "consul_keys" "nginx_signing" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    count      = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
    # Set signing key
    key {
        path = "${data.terraform_remote_state.vpc_rs.vdc}/signed/nginx-0${count.index+1}.${var.tld}"
        value = "true"
        delete = true
    }
}

resource "consul_keys" "puppetdb-lb_signing" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    # Set signing key
    key {
        path = "${data.terraform_remote_state.vpc_rs.vdc}/signed/puppetdb-lb.service.ue2.consul"
        value = "true"
        delete = true
    }
}
