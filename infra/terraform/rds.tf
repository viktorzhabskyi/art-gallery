
# Create RDS Instance
resource "aws_db_instance" "postgres" {
  identifier              = "ecs-postgres"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = var.db_port
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet.id
  skip_final_snapshot     = true

  depends_on = [aws_vpc.art_gallery]
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name = "db-subnet-group"
  }
}

# Store database credentials in AWS Secrets Manager
#resource "aws_secretsmanager_secret" "db_secret_2" {
#  name        = "ecs-postgres-credentials-2"
#  description = "PostgreSQL credentials for ECS services"
#}
#
#resource "aws_secretsmanager_secret_version" "db_secret_version_2" {
#  secret_id     = aws_secretsmanager_secret.db_secret_2.id
#  secret_string = jsonencode({
#    username = var.db_username
#    password = var.db_password
#    host     = aws_db_instance.postgres.endpoint
#    port     = var.db_port
#    db_name  = var.db_name
#  })
#}