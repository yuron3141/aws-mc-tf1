################################################
# minecraft Server instance
################################################
#########################
# EC2 key pair
#########################
# Configure EC2 key pair resource
# Use for login accsess on EC2 Instance
resource "aws_key_pair" "auth" {

    # Define key pair name for web server
    key_name = "id_rsa.pub"

    # Configure public key for web server
    public_key = data.template_file.ssh_key.rendered
  
}

#########################
# EC2 for minecraft
#########################

# Create AMI Data Source

data "aws_ami" "amzn2" {

    #In case return multiple results, use latest AMI
    most_recent = true

    # List of AMI owners to restrict search
    # In this case use AMI that destribute amazon, configure like a below
    owners = ["amazon"]

    # Set search criteria with one or more name/value pairs
    filter {
        # Filter by the name of the image published in AWS
        name = "name"

        # Extract the following conditions from the image
        # [*] is a wild card
        values = ["amzn2-ami-hvm-*-x86_64-gp2"] #x86_64
    }
}

# Create EC2 minecraft server
resource "aws_instance" "minecraft" {

    # Reference ami(Amazon Linux 2023 AMI)
    ami = data.aws_ami.amzn2.id

    # Configure instance type
    instance_type ="t3a.medium"

    # Reference EC2 key pair
    key_name = aws_key_pair.auth.id

    # Reference iam profile
    iam_instance_profile = aws_iam_instance_profile.ec2_mc_profile.name

    # Reference subnet
    subnet_id = aws_subnet.public_mc.id

    # Reference vpc security group
    vpc_security_group_ids = [aws_security_group.public_mc.id]

    # Configure EBS params
    root_block_device {
      
        # Volume Type
        # In this case gp2
        # standard gp2 iol scl stl
        volume_type = "gp2"

        # Configure Volume Capacity
        # Unit is GiB
        volume_size = 20

        # Configure Volume also destroyed when Instance destroyed
        delete_on_termination = true
    }

    associate_public_ip_address = true  # EIP assoctiate
    
    tags = {
        Name = "minecraft-instance"
    }

    # Reference shell script
    # Storage setting encode by base64
    user_data = base64encode(data.template_file.mc_shell.rendered)

    # Export Instance ID
    provisioner "local-exec" {
        command = "echo ${aws_instance.minecraft.id} > instance_id.txt"
    }
}