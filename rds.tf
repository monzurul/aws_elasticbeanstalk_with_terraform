#RDS

resource "aws_db_instance" "aurora_db" {
  allocated_storage    = 100
  storage_type         = "gp2"
  engine               = "aurora"
  engine_version       = "5.6.27"
  instance_class       = "${var.db_instance_class}"
  name                 = "${var.dbname}"
  username             = "${var.dbuser}"
  password             = "${var.dbpassword}"
  db_subnet_group_name = "${aws_db_subnet_group.rds_subnetgroup.name}"

  #vpc_security_group_ids  = ["${aws_security_group.RDS.id}"]
  parameter_group_name    = "default.aurora5.6"
  backup_retention_period = 7
  publicly_accessible     = true
  skip_final_snapshot     = true
  multi_az                = true
  port                    = 3306
  copy_tags_to_snapshot   = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
}
