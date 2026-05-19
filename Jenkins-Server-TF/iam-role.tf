resource "aws_iam_role" "iam-role" {
  name               = var.iam-role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
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

#any ec2 instance can use this role 
    #allow ec2 instance to assume this role and get the permissions attached to it Temporary Credentials
    #json policy define who allow use that role 