resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-vpc"
    Description = "VPC for ${var.environment} environment"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }

  lifecycle {
    precondition {
      condition     = tonumber(split("/", each.value.cidr)[1]) > tonumber(split("/", var.cidr_block)[1])
      error_message = "Public subnet CIDR block must be smaller than VPC CIDR block"
    }
  }
}

resource "aws_subnet" "private_subnet" {
  for_each                = var.private_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = each.key
  }

  lifecycle {
    precondition {
      condition     = tonumber(split("/", each.value.cidr)[1]) > tonumber(split("/", var.cidr_block)[1])
      error_message = "Private subnet CIDR block must be smaller than VPC CIDR block"
    }
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.environment}-vpc-public-route"
  }
}

resource "aws_route_table_association" "public_associations" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat_elastic_ip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-vpc-elastic-ip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  vpc_id            = aws_vpc.vpc.id
  availability_mode = "regional"

  tags = {
    Name = "${var.environment}-vpc-nat-gateway"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.environment}-vpc-private-route"
  }
}

resource "aws_route_table_association" "private_associations" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private.id
}