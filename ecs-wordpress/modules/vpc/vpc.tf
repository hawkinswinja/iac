# VPC, internet Gateway and Subnet creation

resource "aws_vpc" "ecs-vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name    = var.vpc_name
    Project = "${var.vpc_name}-vpc"
  }
}

resource "aws_internet_gateway" "ecs-igw" {
  vpc_id = aws_vpc.ecs-vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "ecs-public-subnet" {
  count = length(var.public_subnet_cidr)

  vpc_id            = aws_vpc.ecs-vpc.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "ecs-private-subnet" {
  count = length(var.private_subnet_cidr)

  vpc_id            = aws_vpc.ecs-vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index}"
  }
}

output  "ecs-private-subnet" {
  value = aws_subnet.ecs-private-subnet[*].id
}