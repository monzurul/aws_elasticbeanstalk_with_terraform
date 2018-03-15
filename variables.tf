variable "aws_region" {}
variable "aws_profile" {}
variable "shared_credentials_file" {}
data "aws_availability_zones" "available" {}
variable "localip" {}
variable "db_instance_class" {}
variable "dbname" {}
variable "dbuser" {}
variable "dbpassword" {}
variable "eb_site1_instance_type" {}
variable "eb_app1_instance_type" {}
variable "eb_worker1_instance_type" {}
variable "dns_zone_name_1" {}
variable "dns_zone_name_2" {}
variable "vpc_cidrs" {}

variable "cidrs" {
  type = "map"
}

variable "s3_binary_bucket" {}
variable "eb_loadbalancer_type" {}
variable "elasticache_parameter_group_name" {}
variable "elasticache_cluster_id" {}
variable "elasticache_instance_type" {}
variable "elasticache_engine_version" {}
variable "elasticache_node_groups" {}

# tags
variable "tag_environment" {}
