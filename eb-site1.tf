# The prod app-main environment
resource "aws_elastic_beanstalk_environment" "live-sites" {
  name                = "live-sites"
  application         = "${aws_elastic_beanstalk_application.live-applications.name}"
  solution_stack_name = "64bit Amazon Linux 2017.09 v2.6.5 running PHP 7.1"
  tier                = "WebServer"

  setting {
    name      = "InstanceType"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = "${var.eb_site1_instance_type}"
  }

  setting {
    name      = "MinSize"
    namespace = "aws:autoscaling:asg"
    value     = "1"
  }

  setting {
    name      = "MaxSize"
    namespace = "aws:autoscaling:asg"
    value     = "4"
  }

  # This is the VPC that the instances will use.
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.vpc.id}"
  }

  # This is the subnet of the ELB
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${aws_subnet.public1.id}, ${aws_subnet.public2.id}"
  }

  # This is the subnets for the instances.
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.public1.id}, ${aws_subnet.public2.id}"
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
    value     = "Production"
  }

  setting {
    name      = "Availability Zones"
    namespace = "aws:autoscaling:asg"
    value     = "Any 2"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "${var.eb_loadbalancer_type}"
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
    name      = "Unit"
    namespace = "aws:autoscaling:trigger"
    value     = "Percent"
  }

  setting {
    name      = "MeasureName"
    namespace = "aws:autoscaling:trigger"
    value     = "CPUUtilization"
  }

  setting {
    name      = "LowerThreshold"
    namespace = "aws:autoscaling:trigger"
    value     = "30"
  }

  setting {
    name      = "UpperThreshold"
    namespace = "aws:autoscaling:trigger"
    value     = "70"
  }

  setting {
    name      = "UpperBreachScaleIncrement"
    namespace = "aws:autoscaling:trigger"
    value     = "1"
  }

  setting {
    name      = "LowerBreachScaleIncrement"
    namespace = "aws:autoscaling:trigger"
    value     = "-1"
  }
}
