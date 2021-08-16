variable "aws_access_key" {
    description = "Access key name"
    default = "AKIARJ6EQT2VRD4NQRUU"    
}
variable "aws_secret_key" {}
variable "aws_key_path" {
    description = "SSH key path"
    default = "/Users/tim/.ssh/"    
}
variable "aws_key_name" {
    description = "ssh key name"
    default = "my-key2"     
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "ap-southeast-1"
}

variable "vpc_id" {
    description = "ID of the Corporate VPC"
    default = "vpc-01b7b27ec7cc8d0f6"
}

variable "aws_internet_gateway_id" {
    description = "ID of the Corporate Internet Gateway"
    default = "igw-017e7afb3a5047444"
}

variable "ocp_public_subnet_cidr_a" {
    description = "CIDR for the OCP Public Subnet"
    default = "10.0.16.0/20"
}

variable "ocp_private_subnet_cidr_a" {
    description = "CIDR for the OCP Private Subnet"
    default = "10.0.128.0/20"
}