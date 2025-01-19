
# Security Group for RDS and ElasticCache
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow ECS to connect to RDS and Redis"
  vpc_id      = aws_vpc.art_gallery.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create ElasticCache Redis Cluster
resource "aws_elasticache_subnet_group" "redis_subnet" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.private_a.id,aws_subnet.private_b.id]
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "ecs-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet.id
  security_group_ids   = [aws_security_group.db_sg.id]
  parameter_group_name = "default.redis7"

  depends_on = [aws_vpc.art_gallery]
}
