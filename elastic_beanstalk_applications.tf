provider "aws" {
	region = "${var.region}"
	profile = "${var.profile}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "staging_vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
        Name = "staging_vpc"
  }  
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "staging_igw" {
  vpc_id = "${aws_vpc.staging_vpc.id}"

  tags {
        Name = "staging_igw"
  }  
}

# Grant the VPC internet access on its main route table
resource "aws_route" "staging_internet_rt" {
  route_table_id         = "${aws_vpc.staging_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.staging_igw.id}"
}

# Create a subnet for the ELB & EC2 intances
resource "aws_subnet" "public_staging_sn_1a" {
  vpc_id                  = "${aws_vpc.staging_vpc.id}"
  availability_zone       = "ap-southeast-1a"
  cidr_block              = "10.10.0.0/24"
  map_public_ip_on_launch = true

  tags {
        Name = "public_staging_sn_1a"
  }
}

# Create a subnet for the ELB & EC2 intances
resource "aws_subnet" "public_staging_sn_1b" {
  vpc_id                  = "${aws_vpc.staging_vpc.id}"
  availability_zone       = "ap-southeast-1b"
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true

  tags {
        Name = "public_staging_sn_1b"
  }  
}

# Create a subnet for the RDS intances
resource "aws_subnet" "private_staging_sn_1a" {
  vpc_id                  = "${aws_vpc.staging_vpc.id}"
  availability_zone       = "ap-southeast-1a"
  cidr_block              = "10.10.2.0/24"
  map_public_ip_on_launch = false

  tags {
        Name = "private_staging_sn_1a"
  }  
}

# Create a subnet for the RDS intances
resource "aws_subnet" "private_staging_sn_1b" {
  vpc_id                  = "${aws_vpc.staging_vpc.id}"
  availability_zone       = "ap-southeast-1b"
  cidr_block              = "10.10.3.0/24"
  map_public_ip_on_launch = false

  tags {
        Name = "private_staging_sn_1b"
  }  
}

