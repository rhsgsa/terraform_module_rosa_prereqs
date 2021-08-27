# variable "aws_access_key" {
#     description = "Access key name"
#     default = "AKIARJ6EQT2VRD4NQRUU"    
# }

# variable "aws_secret_key" {}
# variable "aws_key_path" {
#     description = "SSH key path"
#     default = "/Users/ltsai/.ssh/"    
# }
# variable "aws_key_name" {
#     description = "ssh key name"
#     default = "worklaptop_aws_rsa.pub"     
# }

variable "aws_profile" {
    description = "AWS profile"
    default = "default"
}

resource "random_id" "server" {  
    byte_length = 4

    keepers = {
        public_cidr_a = "${var.ocp_public_subnet_cidr_a}"
    }
}

locals {
    cluster_name = "rosa-${random_id.server.hex}"
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