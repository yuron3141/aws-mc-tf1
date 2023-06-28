# Elastic IP(static ip)
resource "aws_eip" "ngw_public_mc" {

    //instance = aws_instance.minecraft.id

    domain = "vpc"

    # Tag settings
    tags = {
        Name = "ngw-public-a"
    }
}

resource "aws_eip_association" "associate_eip_toEC2" {
  instance_id   = aws_instance.minecraft.id
  allocation_id = aws_eip.ngw_public_mc.id
}