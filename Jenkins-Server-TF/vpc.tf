resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.vpc-name
  }
}
#allow vpc to connect to the internet and make jenkins server accessible from the internet and make ssh and download packages easier
resource "aws_internet_gateway" "igw" { 
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw-name
  }
}

#small part of vpc and make any ec2 to take public ip when launch the instance in this subnet
#the place where ec2 server will be launcheds
resource "aws_subnet" "public-subnet" { 
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet-name
  }
}

#any traffic from the internet to the instance will be routed to the igw and then to the instance through this route table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.rt-name
  }
}

#connect subnet with route table 
resource "aws_route_table_association" "rt-association" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.public-subnet.id
}

resource "aws_security_group" "security-group" {
  vpc_id      = aws_vpc.vpc.id
  description = "Allowing Jenkins, Sonarqube, SSH Access"

  ingress = [ #to enter the instance from the internet, we need to allow traffic to the instance through these ports
    for port in [22, 8080, 9000] : { #ssh jenkins and sonarqube port
      description      = "TLS from VPC" 
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"] #any traffic from the internet can access the instance through these ports, but we will use security group to restrict the traffic to only our ip address in the next step
    }
  ]

  egress { #outside traffic from the instance to the internet, we need to allow traffic from the instance to the internet through these ports
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg-name
  }
}