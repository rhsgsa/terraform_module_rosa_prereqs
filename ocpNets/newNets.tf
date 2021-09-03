/*
  Public Subnet
*/
resource "aws_subnet" "ap-southeast-1-public" {
    vpc_id = var.vpc_id

    cidr_block = var.ocp_public_subnet_cidr_a
    availability_zone = "ap-southeast-1a"

    tags = {
        Name = "OCP Public Subnet AZ A"
    }
}

resource "aws_route_table" "ap-southeast-1-public" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.aws_internet_gateway_id
    }

    tags = {
        Name = "OCP Public Subnet AZ A"
    }
}

resource "aws_route_table_association" "ap-southeast-1-public" {
    subnet_id = aws_subnet.ap-southeast-1-public.id
    route_table_id = aws_route_table.ap-southeast-1-public.id
}

/*
  Private Subnet
  We need to create a NAT-Gateway for each private subnet
*/
resource "aws_subnet" "ap-southeast-1-private" {
    vpc_id = var.vpc_id

    cidr_block = var.ocp_private_subnet_cidr_a
    availability_zone = "ap-southeast-1a"

    tags = {
        Name = "OCP Private Subnet AZ A"
    }
}

resource "aws_eip" "natgw_a_eip" {
  vpc = true
  tags = {
    Name = "OCP NAT GW EIP"
  }
}

resource "aws_nat_gateway" "natgw_a" {
  allocation_id = aws_eip.natgw_a_eip.id
  subnet_id     = aws_subnet.ap-southeast-1-public.id

  tags = {
    Name = "OCP GW NAT AZ A"
  }
}

resource "aws_route_table" "ap-southeast-1-private" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw_a.id
    }

    tags = {
        Name = "OCP Private Subnet AZ A"
    }
}

resource "aws_route_table_association" "ap-southeast-1-private" {
    subnet_id = aws_subnet.ap-southeast-1-private.id
    route_table_id = aws_route_table.ap-southeast-1-private.id
}