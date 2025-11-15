resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  instance_tenancy = "default"

  tags = merge(
    local.default_tags,
    { Name = "vpc1-${local.stack}" }
  )
}

resource "aws_security_group" "sg" {
  name   = "sg1-${local.stack}"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = merge(
    local.default_tags,
    { Name = "sg1-${local.stack}" }
  )
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.availability-zone
  cidr_block = var.subnet-cidr

  tags = merge(
    local.default_tags,
    { Name = "subnet1-${local.stack}" }
 )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.default_tags,
    { Name = "igw1-${local.stack}" }
  )
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.default_tags,
    { Name = "rt1-${local.stack}" }
  )
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}
