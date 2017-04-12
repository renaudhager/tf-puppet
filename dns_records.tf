#
# Consul key for FQDN
#
resource "consul_keys" "puppetca" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"

    # Create the entry for DNS
    key {
        path = "app/bind/${data.terraform_remote_state.vpc_rs.vdc}.lan/${var.puppet_ca_hostname}"
        value = "A ${aws_instance.puppetca.private_ip}"
        delete = true
    }
}

resource "consul_keys" "puppetdb_pgsql" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"

    # Create the entry for DNS
    key {
        path = "app/bind/${data.terraform_remote_state.vpc_rs.vdc}.lan/puppetdb-pgsql-01"
        value = "A ${aws_instance.puppetdb_pgsql.private_ip}"
        delete = true
    }
}

resource "consul_keys" "puppetdb" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    count      = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
    # Create the entry for DNS
    key {
        path = "app/bind/${data.terraform_remote_state.vpc_rs.vdc}.lan/puppetdb-0${count.index+1}"
        value = "A ${element(aws_instance.puppetdb.*.private_ip, count.index)}"
        delete = true
    }
}

resource "consul_keys" "puppetmaster" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    count      = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
    # Create the entry for DNS
    key {
        path = "app/bind/${data.terraform_remote_state.vpc_rs.vdc}.lan/puppetmaster-0${count.index+1}"
        value = "A ${element(aws_instance.puppetmaster.*.private_ip, count.index)}"
        delete = true
    }
}

resource "consul_keys" "nginx" {
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
    count      = "${length( split( ",", lookup( var.azs, var.region ) ) )}"
    # Create the entry for DNS
    key {
        path = "app/bind/${data.terraform_remote_state.vpc_rs.vdc}.lan/nginx-0${count.index+1}"
        value = "A ${element(aws_instance.nginx.*.private_ip, count.index)}"
        delete = true
    }
}
