provider "aws" {
  region     = "ap-southeast-1"
  access_key = "AKIAT4GVRUUS2TAMXLPP"
  secret_key = "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"
}

#VPC
resource "aws_vpc" "barkeley" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "barkeley-vpc"
  }
}

#IGW
resource "aws_internet_gateway" "bgw" {
  vpc_id = aws_vpc.barkeley.id
  tags = {
    Name = "bgw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "NAT Gateway EIP"
  }
}

# NAT Gateway for Private Subnet
# resource "aws_nat_gateway" "nat" {
#   allocation_id     = aws_eip.nat.id
#   subnet_id         = aws_subnet.public_subnet.id
#   connectivity_type = "public"

#   tags = {
#     Name = "NAT Gateway"
#   }
# }


#Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.barkeley.id
  tags = {
    Name = "public-route-table"
  }
}

# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.barkeley.id
#   tags = {
#     Name = "Private Route Table"
#   }
#}

#Route
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.bgw.id
}

# resource "aws_route" "private_route" {
#   route_table_id         = aws_route_table.private_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }

#Public Subnet
# resource "aws_subnet" "public_subnet" {
#   vpc_id                  = aws_vpc.barkeley.id
#   cidr_block              = var.public_subnets[0].cidr_block
#   availability_zone       = var.public_subnets[0].az
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "public-subnet-${var.public_subnets[0].az}"
#   }
# }

#Public Subnet
resource "aws_subnet" "public_subnet" {
  for_each          = { for subnet in var.public_subnets : subnet.az => subnet }
  vpc_id            = aws_vpc.barkeley.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${each.value.az}"
  }
}

#Route Table Associations
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

# resource "aws_route_table_association" "private" {
#   for_each = aws_subnet.private_subnet

#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.private_route_table.id
# }