
######################
# Private S3 Bucket
# <Caution>
# if you create private bucket, you have to empower accsess authority to EC2 using iam_role
# </Caution>
######################
resource "aws_s3_bucket" "minecraft_bucket" {

  bucket = var.s3_mc_bucket_name

  force_destroy = true

  tags = {
    Name = "unit-minecraft-world"
  }
}
# Below is not need in2023 4 ~
# reference: https://dev.classmethod.jp/articles/s3-acl-error-from-202304/
/*
resource "aws_s3_bucket_acl" "private_bucket_acl" {
  bucket = aws_s3_bucket.minecraft_bucket.id

  # Set the ACL to private
  # Only the bucket owner has access
  acl = "private"
}
*/
resource "aws_s3_bucket_versioning" "private_bucket_versioning" {
  bucket = aws_s3_bucket.minecraft_bucket.id

  # Enable versioning
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "private_bucket_sse" {
  bucket = aws_s3_bucket.minecraft_bucket.id

  # Enable crypto by AES256
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}