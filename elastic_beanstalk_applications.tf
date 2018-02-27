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

# The elastic beanstalk application
resource "aws_elastic_beanstalk_application" "staging_application" {
  name = "StagingApplication"
  description = "StagingApplication"
}

# The staging environment
resource "aws_elastic_beanstalk_environment" "staging_app" {
  name                  = "stagingapp"
  application           = "${aws_elastic_beanstalk_application.staging_application.name}"
  solution_stack_name   = "64bit Amazon Linux 2017.09 v2.6.5 running PHP 7.1"
  tier                  = "WebServer"

  setting {
    name = "InstanceType"
    namespace = "aws:autoscaling:launchconfiguration"
    value = "t2.micro"
  }

  setting {
    name = "MinSize"
    namespace = "aws:autoscaling:asg"
    value = "1"
  }
  setting {
    name = "MaxSize"
    namespace = "aws:autoscaling:asg"
    value = "4"
  }

  # This is the VPC that the instances will use.
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.staging_vpc.id}"
  }

  # This is the subnet of the ELB
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${aws_subnet.public_staging_sn_1a.id}"
  }

  # This is the subnets for the instances.
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.public_staging_sn_1a.id}"
  }

  # You can set the environment type, single or LoadBalanced
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  # Example of setting environment variables
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_ENVIRONMENT"
    value     = "staging"
  }

  setting {
    name = "Availability Zones"
    namespace = "aws:autoscaling:asg"
    value = "Any 2"
  }

  # Are the load balancers multizone?
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }

  # Enable connection draining.
  setting {
    namespace = "aws:elb:policies"
    name      = "ConnectionDrainingEnabled"
    value     = "true"
  }

  setting {
    name = "Unit"
    namespace = "aws:autoscaling:trigger"
    value = "Percent"
  }
  setting {
    name = "MeasureName"
    namespace = "aws:autoscaling:trigger"
    value = "CPUUtilization"
  }
  setting {
    name = "LowerThreshold"
    namespace = "aws:autoscaling:trigger"
    value = "40"
  }
  setting {
    name = "UpperThreshold"
    namespace = "aws:autoscaling:trigger"
    value = "80"
  }
  setting {
    name = "UpperBreachScaleIncrement"
    namespace = "aws:autoscaling:trigger"
    value = "1"
  }
  setting {
    name = "LowerBreachScaleIncrement"
    namespace = "aws:autoscaling:trigger"
    value = "-1"
  }
}