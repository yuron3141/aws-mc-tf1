# Elastic IP(static ip)
resource "aws_eip" "ngw_public_mc" {

    instance = aws_instance.minecraft.id

    vpc = true

    # Tag settings
    tags = {
        Name = "ngw-public-a"
    }
}