 #this code use to create ec2 instance
 resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = "m7i-flex.large" #instance type with 2 vCPU and 8 GB of memory
  key_name               = var.key-name # ssh key to connect to the instance
  subnet_id              = aws_subnet.public-subnet.id  #subnet to launch the instance in
  # puplic to make jenkins server accessible from the internet and make ssh and download packages easier
  vpc_security_group_ids = [aws_security_group.security-group.id] 
  #firewall to allow traffic to the instance and available ports for jenkins and ssh
  iam_instance_profile   = aws_iam_instance_profile.instance-profile.name
  # give ec2 instance permission to access other aws services like s3 and cloudwatch
  root_block_device {
    volume_size = 20 #size of the root volume in GB
  }
  #user_data = templatefile("./tools-install.sh", {})
  #scirpt to install jenkins and other tools on the instance when it is launched

  tags = {
    Name = var.instance-name #name of server to identify it in the aws console
  }
}