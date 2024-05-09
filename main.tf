# VPC Resource
#=================================================
resource "aws_vpc" "this" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = var.vpc_name
  }
}

# AWS internet gateway resource
#===================================================
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "${var.vpc_name}-ig"
  }
}

# AWS public subnets
#====================================================
resource "aws_subnet" "pub-sub-1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.pub-sub-1_cidr
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.vpc_name}-pub-sub-1"
  }
}

resource "aws_subnet" "pub-sub-2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.pub-sub-2_cidr
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.vpc_name}-pub-sub-2"
  }
}

# AWS private subnets
#====================================================
resource "aws_subnet" "pvt-sub-1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.pvt-sub-1_cidr
  availability_zone = var.availability_zone_1
  tags = {
    "Name" = "${var.vpc_name}-pvt-sub-1"
  }
}

resource "aws_subnet" "pvt-sub-2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.pvt-sub-2_cidr
  availability_zone = var.availability_zone_2
  tags = {
    "Name" = "${var.vpc_name}-pvt-sub-2"
  }
}

# AWS NAT gateways
#====================================================
resource "aws_eip" "nat-eip-1" {
  tags = {
    "Name" = "nat-eip-1"
  }
}

resource "aws_eip" "nat-eip-2" {
  tags = {
    "Name" = "nat-eip-2"
  }
}

resource "aws_nat_gateway" "nat-gw-1" {
  allocation_id = aws_eip.nat-eip-1.id
  subnet_id     = aws_subnet.pub-sub-1.id
  tags = {
    "Name" = "${var.vpc_name}-nat-gw-1"
  }
}

resource "aws_nat_gateway" "nat-gw-2" {
  allocation_id = aws_eip.nat-eip-2.id
  subnet_id     = aws_subnet.pub-sub-2.id
  tags = {
    "Name" = "${var.vpc_name}-nat-gw-2"
  }
}

# Routes and route tables
#====================================================
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "${var.vpc_name}-pub-rt"
  }
}

resource "aws_route" "public-route-1" {
  route_table_id         = aws_route_table.pub-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "public-route-2" {
  route_table_id         = aws_route_table.pub-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table" "pvt-rt-1" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "${var.vpc_name}-pvt-rt-1"
  }
}

resource "aws_route_table" "pvt-rt-2" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "${var.vpc_name}-pvt-rt-2"
  }
}

resource "aws_route" "private-route-1" {
  route_table_id         = aws_route_table.pvt-rt-1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw-1.id
}

resource "aws_route" "private-route-2" {
  route_table_id         = aws_route_table.pvt-rt-2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw-2.id
}

resource "aws_route_table_association" "pub-sub-1-assoc" {
  subnet_id      = aws_subnet.pub-sub-1.id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table_association" "pub-sub-2-assoc" {
  subnet_id      = aws_subnet.pub-sub-2.id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table_association" "pvt-sub-1-assoc" {
  subnet_id      = aws_subnet.pvt-sub-1.id
  route_table_id = aws_route_table.pvt-rt-1.id
}

resource "aws_route_table_association" "pvt-sub-2-assoc" {
  subnet_id      = aws_subnet.pvt-sub-2.id
  route_table_id = aws_route_table.pvt-rt-2.id
}

