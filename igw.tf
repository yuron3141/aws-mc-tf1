# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.minecraft_vpc.id

    tags = {
        Name = "igw"
    }
}
