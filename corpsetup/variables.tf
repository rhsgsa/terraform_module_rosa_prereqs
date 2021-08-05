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

variable "amis" {
    description = "AMIs by region"
    default = {
        ap-southeast-1 = "ami-f1810f86" 	# ubuntu 14.04 LTS   ami-03a4a9b0b0197b758
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Corporate Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Corporate Private Subnet"
    default = "10.0.1.0/24"
}