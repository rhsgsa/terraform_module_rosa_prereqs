variable "aws_profile" {
    description = "AWS profile"
    default = "default"
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "ap-southeast-1"
}

variable "vpc_id" {
    description = "ID of the Corporate VPC"
    default = "vpc-0b17569ec89f4bdec"
}

variable "aws_internet_gateway_id" {
    description = "ID of the Corporate Internet Gateway"
    default = "igw-0d6963bdb0ef39341"
}

variable "ocp_public_subnet_cidr_a" {
    description = "CIDR for the OCP Public Subnet"
    default = "10.114.0.0/27"
}

variable "ocp_private_subnet_cidr_a" {
    description = "CIDR for the OCP Private Subnet"
    default = "10.114.0.32/27"
}