# NAT Gateway
resource "aws_nat_gateway" "ngw_public_mc" {
    # Configure the Elastic IP Allocation ID to be associated with the NATGW
    allocation_id = aws_eip.ngw_public_mc.id

    # Subnet ID where the NATGW will be deployed
    subnet_id = aws_subnet.public_mc.id

    tags = {
        Name = "ngw-public-a"
    }
}