
resource "aws_ecs_cluster" "art_gallery_ecs_cluster" {
  name = "art_gallery_ecs_cluster"
}

# Task Definition
resource "aws_ecs_task_definition" "ecs_task_frontend" {
  family                   = "art_gallery_ecs_task_frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  cpu                   = "256" # 0.25 vCPU
  memory                = "512" # 512 MiB

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "638693734667.dkr.ecr.us-east-1.amazonaws.com/art-gallery:frontend-2221275-linux-amd64"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
      environment = [
        {
          name  = "BACKEND_REDIS_URL"
          value = "http://${aws_lb.alb.dns_name}/redis/test_connection/"
        },
        {
          name  = "BACKEND_RDS_URL"
          value = "http://${aws_lb.alb.dns_name}/rds/test_connection/"
        }
      ]
    }
  ])

  depends_on = [
    aws_db_instance.postgres,
    aws_elasticache_cluster.redis
  ]
}

resource "aws_ecs_task_definition" "ecs_task_rds" {
  family                   = "art_gallery_ecs_task_rds"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  cpu                   = "256" # 0.25 vCPU
  memory                = "512" # 512 MiB

  container_definitions = jsonencode([
    {
      name      = "backend_rds"
      image     = "638693734667.dkr.ecr.us-east-1.amazonaws.com/art-gallery:backend_rds-2221275-linux-amd64"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
      environment = [
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_USER"
          value = var.db_username
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "DB_PORT"
          value = tostring(var.db_port)
        },
        {
          name  = "DB_HOST"
          value = aws_db_instance.postgres.address
        }
      ]
    }
  ])

  depends_on = [
    aws_db_instance.postgres
  ]
}

resource "aws_ecs_task_definition" "ecs_task_redis" {
  family                   = "art_gallery_ecs_task_redis"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  cpu                   = "256" # 0.25 vCPU
  memory                = "512" # 512 MiB

  container_definitions = jsonencode([
    {
      name      = "backend_redis"
      image     = "638693734667.dkr.ecr.us-east-1.amazonaws.com/art-gallery:backend_redis-2221275-linux-amd64"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
      environment = [
        {
          name  = "REDIS_HOST"
          value = aws_elasticache_cluster.redis.cache_nodes[0].address
        },
        {
          name  = "REDIS_PORT"
          value = tostring(aws_elasticache_cluster.redis.cache_nodes[0].port)
        },
        {
          name  = "REDIS_DB"
          value = "0"
        },
        {
          name  = "REDIS_PASSWORD"
          value = ""
        }
      ]
    }
  ])

  depends_on = [
    aws_elasticache_cluster.redis
  ]
}

# ECS Services
resource "aws_ecs_service" "ecs_service_frontend" {
  name            = "ecs_service_frontend"
  cluster         = aws_ecs_cluster.art_gallery_ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_frontend.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_a.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group_frontend.arn
    container_name   = "frontend"
    container_port   = 8000
  }
}

resource "aws_ecs_service" "ecs_service_rds" {
  name            = "ecs_service_rds"
  cluster         = aws_ecs_cluster.art_gallery_ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_rds.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_a.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group_rds.arn
    container_name   = "backend_rds"
    container_port   = 8000
  }
}

resource "aws_ecs_service" "ecs_service_redis" {
  name            = "ecs_service_redis"
  cluster         = aws_ecs_cluster.art_gallery_ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_redis.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_a.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group_redis.arn
    container_name   = "backend_redis"
    container_port   = 8000
  }
}

