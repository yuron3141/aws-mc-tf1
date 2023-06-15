# VPC
resource "aws_vpc" "minecraft_vpc" {

    # Network range
    cidr_block = var.vpc_cidr_block

    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags = {
        Name = "minecraft-vpc"
    }
  
}