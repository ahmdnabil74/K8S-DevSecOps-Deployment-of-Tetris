resource "aws_iam_instance_profile" "instance-profile" {
  name = "Jenkins-instance-profile"
  role = aws_iam_role.iam-role.name
}
# ec2 can't use iam role directly, it need to use iam instance profile to attach the role to the instance

#EC2 Instance
#     ↓
#Instance Profile
#     ↓
#IAM Role
#    ↓
#Permissions (S3, ECR, EKS...)