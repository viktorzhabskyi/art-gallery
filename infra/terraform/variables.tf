variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}
variable "public_subnet_cidr_2" {
  default = "10.0.4.0/24"
}

variable "private_subnet_a_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet_b_cidr" {
  default = "10.0.3.0/24"
}

variable "db_name" {
  default = "postgres"
}

variable "db_username" {
  default = "user1"
}

variable "db_password" {
  default = "securepassword123!"
}

variable "db_port" {
  default = 5432
}