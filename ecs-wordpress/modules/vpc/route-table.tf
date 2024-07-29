# Routing table, subnet associations and ECR

resource "aws_route_table" "public-route-table" {
    vpc_id = aws_vpc.ecs-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ecs-igw.id
    }

    route {
        cidr_block = var.vpc_cidr
        gateway_id = "local"
    }

    tags = {
        key = "Name"
        value = "${var.vpc_name}-public-rt"
    }
}

resource "aws_route_table" "private-route-table" {
    vpc_id = aws_vpc.ecs-vpc.id

    route {
        cidr_block = var.vpc_cidr
        gateway_id = "local"
    }

    tags = {
        key = "Name"
        value = "${var.vpc_name}-private-rt"
    }
}

resource "aws_route_table_association" "subnet-association" {
    count          = length(var.subnet_cidr)
    subnet_id      = element(aws_subnet.ecs-subnet[*].id, count.index)
    route_table_id = count.index % 2 == 0 ? aws_route_table.public-route-table.id : aws_route_table.private-route-table.id
}

resource "aws_ecr_repository" "repo" {
  name                 = "${var.vpc_name}-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}