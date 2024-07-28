provider "aws" {
  region = "us-west-2"
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora"
  master_username         = "aurora_master"
  master_password         = "aurora_password"
  skip_final_snapshot     = true
  backup_retention_period = 5
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count              = 3
  identifier         = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.r5.large"
  engine             = "aurora"
}