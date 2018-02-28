provider "aws" {
  shared_credentials_file  = "/home/ziku/.aws/credentials"
	region = "${var.region}"
	profile = "${var.profile}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "vpc-prod" {
    cidr_block = "${var.vpc-prod}"
    #### this 2 true values are for use the internal vpc dns resolution
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
      Name = "prod vpc"
    }
}