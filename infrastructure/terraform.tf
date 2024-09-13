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

#Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.barkeley.id
  tags = {
    Name = "barkeley-route-table"
  }
}

#Route
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.bgw.id
}

#Public Subnet
resource "aws_subnet" "public_subnet" {
  for_each                = { for subnet in var.public_subnets : subnet.az => subnet }
  vpc_id                  = aws_vpc.barkeley.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${each.value.az}"
  }
}

#Private Subnet
# resource "aws_subnet" "private_subnets" {
#   for_each = { for subnet in var.private_subnets : subnet.az => subnet}
#   vpc_id     = aws_vpc.barkeley.id
#   cidr_block = each.value.cidr_block
#   availability_zone = each.value.az
#   tags = {
#     Name = "private-subnet-${each.value.az}"
#   }
# }

#Route Table Associations
resource "aws_route_table_association" "subnet_associations" {
  for_each = aws_subnet.public_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.route_table.id

}