############################################
# Security Group
############################################

# Configure a Security Group where the minecraft server accepts SSH/SFTP
# and HTTP from the client's Global IP

# Build a Security Group recieve SSH/HTTP
resource "aws_security_group" "public_mc" {
  # Configure Security group name
  name = "sg_public_mc"

  # Configure VPC ID is to build security group
  vpc_id = aws_vpc.minecraft_vpc.id

  # Configure Tags
  tags = {
    Name = "sg-public-a"
  }
}
# Configure output communications
resource "aws_security_group_rule" "egress_public_mc" {
  # Define setting that this resource recieve communications
  # Configure egress
  type = "egress"

  ## *Supplyment
  ## egress means output communication setting
  ## ingress means input communication setting


  # Configure port range
  # Allow all trafics
  from_port = 0
  to_port = 0

  # Configure protocols
  # Below configure means all ipv4 trafics can communicate
  protocol =  "-1"

  # Configure the ip range
  # Below configure means all ipv4 trafics can communicate
  cidr_blocks = ["0.0.0.0/0"]

  # Configure security group is given this rule
  security_group_id = aws_security_group.public_mc.id

}
# Configure receiving SSH/SFTP
resource "aws_security_group_rule" "ingress_public_mc_22" {
  # Defined this resource can recieve communications
  # Configure ingress
  type = "ingress"

  # Configure the port range (this means open the 22 port(SSH))
  from_port = "22"
  to_port = "22"

  # Configure TCP protocol
  protocol = "tcp"

  # Configure allow the ip range
  # Please input your client grobal ip
  cidr_blocks = ["${var.my_global_ip}/32"]

  # Configure security group is given this rules
  security_group_id = aws_security_group.public_mc.id

}
# Configure receiving minecraft java communication(25565)
resource "aws_security_group_rule" "ingress_public_mc_25565" {
    # Defined this resource can recieve communications
    # Configure ingress
    type = "ingress"

    # Configure the port range (this means open the 22 port(SSH))
    from_port = "25565"
    to_port = "25565"

    # Configure TCP protocol
    protocol = "tcp"

    # Configure allow the ip range
    cidr_blocks = ["0.0.0.0/0"]

    # Configure security group is given this rules
    security_group_id = aws_security_group.public_mc.id
}