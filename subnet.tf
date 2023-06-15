#########################################
# Subnet for minecraft server
#########################################
# Public Subnet
resource "aws_subnet" "public_mc"{
    vpc_id = aws_vpc.minecraft_vpc.id

    # Configure CIDR settings
    cidr_block = var.public_subnet_cidr_block

    # Configure regions settings
    availability_zone = "${var.AWS_REGION}a"

    # Bind Public IP to Instance started on this Subnet
    map_public_ip_on_launch = true

    # Tag settings
    tags = {
        Name = "public-mc"
    }
}