resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${var.elasticache_cluster_id}"
  replication_group_description = "Redis cluster for Prod"
  engine                        = "redis"
  engine_version                = "${var.elasticache_engine_version}"
  node_type                     = "${var.elasticache_instance_type}"
  parameter_group_name          = "${var.elasticache_parameter_group_name}"
  port                          = "6379"
  subnet_group_name             = "${aws_elasticache_subnet_group.redis-subnetgroup.name}"
  #security_group_ids            = ["${aws_security_group.redis.id}"]
  automatic_failover_enabled    = true
  snapshot_retention_limit      = 5

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = "${var.elasticache_node_groups}"
  }

  tags {
    Name        = "Redis Cache"
    environment = "${var.tag_environment}"
  }
}
