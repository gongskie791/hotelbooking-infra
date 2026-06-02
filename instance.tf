resource "aws_security_group" "backend_sg" {
  name   = "backend-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow traffic from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "backend_instance" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  key_name                    = "practice"
  vpc_security_group_ids      = [aws_security_group.backend_sg.id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  user_data = templatefile("./scripts/init.sh", {
    aws_region     = var.region
    ecr_registry   = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
    ecr_repository = aws_ecr_repository.hotel-booking-backend.name
  })

  user_data_replace_on_change = true
  tags = {
    Name = var.instance_name
  }
}
