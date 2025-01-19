# create vpc
#resource "aws_vpc" "art_gallery" {
#  cidr_block           = var.vpc_cidr
#  enable_dns_support   = true
#  enable_dns_hostnames = true
#  tags = {
#    Name = "art-gallery-vpc"
#  }
#}

data "aws_vpc" "art_gallery" {
  default = true
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.art_gallery.id
  tags = {
    Name = "art-gallery-igw"
  }
}

# Route table
resource "aws_route_table" "art_gallery_public" {
  vpc_id = aws_vpc.art_gallery.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}



#  public subnet
resource "aws_subnet" "art_gallery_public_subnet" {
  vpc_id                  = aws_vpc.art_gallery.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "art_gallery_public_subnet_2" {
  vpc_id                  = aws_vpc.art_gallery.id
  cidr_block              = var.public_subnet_cidr_2
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "public-subnet-2"
  }
}

# link route table with public subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.art_gallery_public_subnet.id
  route_table_id = aws_route_table.art_gallery_public.id
}

# private subnet a
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.art_gallery.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet-a"
  }
}

# private subnet b
resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.art_gallery.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-subnet-b"
  }
}

# route table for private subnet
resource "aws_route_table" "art_gallery_private" {
  vpc_id = aws_vpc.art_gallery.id

  tags = {
    Name = "private-route-table"
  }
}

# link route table for private subnet
resource "aws_route_table_association" "private_a_association" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.art_gallery_private.id
}

resource "aws_route_table_association" "private_b_association" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.art_gallery_private.id
}