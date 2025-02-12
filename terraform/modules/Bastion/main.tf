
#Bastion EC2 
resource "aws_instance" "bastion" {
  count         = 2
  ami           = "ami-04b4f1a9cf54c11d0"  
  instance_type = "t2.micro"

  tags = {
    Name = "Bastion-Host-${count.index + 1}"
  }
}

# Security group for Bastion EC2 
resource "aws_security_group" "lb_sg" {
  name_prefix = "bastion-sec-group" 
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Load balancer for Bastion EC2
resource "aws_lb" "gitlab_lb" {
  name               = "gitlab-loadbalancer"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnets_ids

  tags = {
    Environment = "gitlab-terraform-lb"
  }
}
# Targets groups for Bastion EC2
resource "aws_lb_target_group" "bastion_ssh_tg" {
  name     = "gitlab-loadbalancer-ssh-target"
  port     = 22
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "TCP"
    port     = "22"
  }
}

resource "aws_lb_target_group" "bastion_http_tg" {
  name     = "gitlab-loadbalancer-http-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/"
    port     = "80"
  }
}

#Listeners for Bastion EC2
resource "aws_lb_listener" "frontend_80" {
  load_balancer_arn = aws_lb.gitlab_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bastion_http_tg.arn
  }
}

resource "aws_lb_listener" "bastion_22" {
  load_balancer_arn = aws_lb.gitlab_lb.arn
  port              = 22
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bastion_ssh_tg.arn
  }
}


#Target group attachment for Bastion EC2
resource "aws_lb_target_group_attachment" "bastion_ssh_attachment" {
  count            = length(aws_instance.bastion)
  target_group_arn = aws_lb_target_group.bastion_ssh_tg.arn
  target_id        = aws_instance.bastion[count.index].id
  port             = 22
}

resource "aws_lb_target_group_attachment" "bastion_http_attachment" {
  count            = length(aws_instance.bastion)
  target_group_arn = aws_lb_target_group.bastion_http_tg.arn
  target_id        = aws_instance.bastion[count.index].id
  port             = 80
}