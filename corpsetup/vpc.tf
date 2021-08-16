resource "aws_vpc" "default" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "corporate-aws-vpc"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = aws_vpc.default.id
}

/*
  NAT Instance
*/
resource "aws_security_group" "nat" {
    name = "vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.private_subnet_cidr]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [var.private_subnet_cidr]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 6443
        to_port = 6443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.vpc_cidr]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = aws_vpc.default.id

    tags = {
        Name = "NATSG"
    }
}

resource "aws_instance" "nat" {
    ami = "ami-09de4a0d603aa5aca" # this is a special ami preconfigured to do NAT
    availability_zone = "ap-southeast-1a"
    instance_type = "t2.micro"
    key_name = var.aws_key_name
    vpc_security_group_ids = [aws_security_group.nat.id]
    subnet_id = aws_subnet.ap-southeast-1-public.id
    associate_public_ip_address = true
    source_dest_check = false

    tags = {
        Name = "VPC NAT"
    }
}

resource "aws_eip" "nat" {
    instance = aws_instance.nat.id
    vpc = true
}

/*
  Public Subnet
*/
resource "aws_subnet" "ap-southeast-1-public" {
    vpc_id = aws_vpc.default.id

    cidr_block = var.public_subnet_cidr
    availability_zone = "ap-southeast-1a"

    tags = {
        Name = "Corporate Public Subnet"
    }
}

resource "aws_route_table" "ap-southeast-1-public" {
    vpc_id = aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.default.id
    }

    tags = {
        Name = "Corporate Public Subnet"
    }
}

resource "aws_route_table_association" "ap-southeast-1-public" {
    subnet_id = aws_subnet.ap-southeast-1-public.id
    route_table_id = aws_route_table.ap-southeast-1-public.id
}

/*
  Private Subnet
*/
resource "aws_subnet" "ap-southeast-1-private" {
    vpc_id = aws_vpc.default.id

    cidr_block = var.private_subnet_cidr
    availability_zone = "ap-southeast-1a"

    tags = {
        Name = "Corporate Private Subnet"
    }
}

resource "aws_route_table" "ap-southeast-1-private" {
    vpc_id = aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = aws_instance.nat.id
    }

    tags = {
        Name = "Corporate Private Subnet"
    }
}

resource "aws_route_table_association" "ap-southeast-1-private" {
    subnet_id = aws_subnet.ap-southeast-1-private.id
    route_table_id = aws_route_table.ap-southeast-1-private.id
}