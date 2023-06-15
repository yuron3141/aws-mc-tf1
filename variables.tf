# Unique variable by client that use terraform
variable "AWS_ACCESS_KEY_ID" {
    description = "AWS access key ID"
    type = string
    default = ""
}

variable "AWS_SECRET_ACCESS_KEY" {
    description = "AWS secret access key"
    type = string
    default = ""
}

variable "AWS_REGION" {
    description = "AWS region"
    type = string
    default = ""
}

# Please registor your global ip as a environment variable(GLOBAL_IP) in your client PC
variable "my_global_ip" {
    description = "My global ip"
    type = string
    default = ""
}

################################################
variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
    description = "CIDR block for the public subnet"
    type = string
    default = "10.0.1.0/24"
}
################################################
variable "s3_mc_bucket_name" {
    description = "S3"
    type = string
    default = "unit-minecraft-world"
}
/*
# Mc EC2 instance ID by using tfstate
data "terraform_remote_state" "ec2_instance_id" {
  backend = "local"

  config = {
    path = "instance_id.txt"
  }
}
*/

# start EC2 script by python
data "local_file" "start_mc_archive" {
  filename = "${path.module}/deploy/start_mc_function.zip"
}

# start EC2 script by python
data "local_file" "stop_mc_archive" {
  filename = "${path.module}/deploy/stop_mc_function.zip"
}

#############################################3
# SSH Key for mc server
# Road public key for web server that exist on your local dircetory
data "template_file" "ssh_key"{
  template = file("${path.module}/.ssh/id_rsa.pub")
}
# shell script
data "template_file" "mc_shell" {
  template = file("${path.module}/template/minecraft.sh.tpl")
}