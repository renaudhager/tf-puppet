#
# AWS Provisioning
#
variable "access_key"   {}
variable "secret_key"   {}
variable "owner"        { default = "r.hager" }
variable "tld"          { default = "ue2.aws" }
variable "region"       { default = "us-east-2" }
variable "ssh_key_name" {}

#
# Remote state files defintion
#
variable "vpc_rs_bucket" {}
variable "vpc_rs_key"    {}
variable "bastion_rs_bucket" {}
variable "bastion_rs_key"    {}

#
# Instances stuff
#
variable "instance_puppetca"     { default = "t2.medium" }
variable "instance_puppetmaster" { default = "t2.small" }
variable "instance_pgsql"        { default = "t2.medium" }
variable "instance_puppetdb"     { default = "t2.small" }

#
# Puppet stuff
#
variable "puppet_agent_version"  { default = "1.7.1" }
variable "puppet_server_version" { default = "2.4.0" }
variable "puppet_ca_hostname"    { default = "puppetca-01" }

// variable "azs" {
//   default = {
//     "eu-west-1"      = "a,b,c"
//     "eu-central-1"   = "a,b"
//     "us-east-1"      = "a,b,c"
//     "us-east-2"      = "a,b,c"
//     "us-west-1"      = "a,c"
//     "us-west-2"      = "b,c"
//     "ap-southeast-2" = "a,b,c"
//   }
// }
