data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-vpc"]
  }
}

data "aws_subnet" "subnet" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-subnet"]
  }
}

resource "aws_security_group" "firewall_rules" {
  name_prefix = "${var.environment}-vpc-${var.purpose}-sg"
  description = "Security group for ${var.environment} ${var.purpose} instances"
  vpc_id      = data.aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.firewall_rules
    content {
      protocol    = ingress.value.protocol
      from_port   = (ingress.value.protocol == "icmp") ? 0 : tonumber(lookup(ingress.value, "ports", [0])[0])
      to_port     = (ingress.value.protocol == "icmp") ? 0 : tonumber(lookup(ingress.value, "ports", [0])[0])
      cidr_blocks = ingress.value.source_ips
      description = ingress.value.description
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-vpc-${var.purpose}-sg"
  }
}

