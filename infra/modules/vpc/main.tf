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

