resource "aws_elasticache_cluster" "helium" {
  cluster_id      = "helium_${var.environment}"
  engine          = "redis"
  node_type       = "cache.t3.micro"
  num_cache_nodes = 1
  engine_version  = "7.1.0"
  security_group_ids = [var.elasticache_sg]
}