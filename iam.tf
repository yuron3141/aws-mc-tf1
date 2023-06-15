# Define IAM role for EC2

# Create IAM reference instance_profile
resource "aws_iam_role" "ec2_mc_role" {

    name = "ec2_mc_role"

    # function like a separate directory about iam role
    path ="/"

    # Configure assume_rule_policy that EC2 temporarily access other resources and s3
    assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AssumeRoleStatement",
                "Effect": "Allow",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    EOF
}
/*
resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3_access_policy"
  description = "Policy for EC2 access to S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3AccessStatement",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObjectAcl",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${var.s3_mc_bucket_name}/*",
        "arn:aws:s3:::${var.s3_mc_bucket_name}",
        "arn:aws:s3:::packages.*.amazonaws.com/*",
        "arn:aws:s3:::repo.*.amazonaws.com/*"
      ]
    }
  ]
}
EOF
}
*/
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.ec2_mc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Associate instance_profile about EC2 and iam_role
# chooce iam _role that reference aws_iam_instance_profile
resource "aws_iam_instance_profile" "ec2_mc_profile" {

    name = "ec2-mc-profile"

    # reference IAM role that created aws_iam_role
    role = aws_iam_role.ec2_mc_role.name
    
}

################################################
# Create IAM cloudwatch can call auto execution
resource "aws_iam_role" "cwatch_mc_role" {

    name = "cwatch_mc_role"

    # function like a separate directory about iam role
    path ="/"

    # Configure assume_rule_policy that EC2 temporarily access other resources
    assume_role_policy = <<EOF
    {
  "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "Service": "events.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
}
EOF
}

#########################################################
# IAM for lambda to stop and start EC2
resource "aws_iam_role" "iam_for_lambda_mcEC2" {
    name = "iam_for_lambda_mcEC2"

    # function like a separate directory about iam role
    path ="/"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AssumeRoleStatement",
      "Effect": "Allow",
      "Principal": {
        "Service": ["lambda.amazonaws.com", "ec2.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_policy" "lambda_access_policy" {
  name = "lambda_access_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Start*",
        "ec2:Stop*"
      ],
      "Resource": "arn:aws:ec2:${var.AWS_REGION}:*:instance/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "mcEC2_lambda_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda_mcEC2.name
  policy_arn = aws_iam_policy.lambda_access_policy.arn
}