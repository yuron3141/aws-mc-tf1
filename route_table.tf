#############################################
# Public Subnet Route Table
#############################################
# Defined Route Table for Public Subnet
resource "aws_route_table" "public_mc" {
    vpc_id = aws_vpc.minecraft_vpc.id

    # Configure communitcation Route
    # Routing for all IPv4 that use this IGW

    route {
        cidr_block= "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "rtb-public-a"
    } 
}

# Associated route table and public subnet
resource "aws_route_table_association" "public_mc"{
    # Configure subnet id
    subnet_id = aws_subnet.public_mc.id

    # Configure route table id prepared 
    route_table_id = aws_route_table.public_mc.id
}
