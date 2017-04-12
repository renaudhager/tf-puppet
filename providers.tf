#
# PROVIDERS
#
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# Configure the Consul provider
provider "consul" {
    address = "consul:80"
    datacenter = "${data.terraform_remote_state.vpc_rs.vdc}"
}

output "region" {
  value = "${var.region}"
}
