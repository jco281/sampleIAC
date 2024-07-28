provider "aws" {
  region = "us-west-2"
}

resource "aws_dynamodb_table" "session_table" {
  name           = "session-state"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "sessionId"

  attribute {
    name = "sessionId"
    type = "S"
  }

  tags = {
    Name = "SessionTable"
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
}
