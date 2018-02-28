variable "region" {
	default = "ap-southeast-1"
}
variable "profile" {
	default = "ecat"
}
variable "vpc-prod" {
  	default = "10.10.0.0/16"
  	description = "The vpc cdir"
}
variable "Subnet-Public-AzA-CIDR" {
  	default = "10.10.0.0/24"
  	description = "The cidr of the subnet"
}
variable "Subnet-Public-AzB-CIDR" {
  	default = "10.10.1.0/24"
  	description = "The cidr of the subnet"
}
variable "Subnet-Private-AzA-CIDR" {
  default = "10.10.2.0/24"
  description = "The cidr of the subnet"
}
variable "Subnet-Private-AzB-CIDR" {
  default = "10.10.3.0/24"
  description = "The cidr of the subnet"
}
variable "key_name" {
  default = ""
  description = "the ssh key to use in the EC2 machines"
}
variable "DnsZoneName" {
  default = "ecat-internal.cue.cloud"
  description = "the internal dns name"
}