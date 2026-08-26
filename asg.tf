data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Launch Template & ASG for Web Tier
resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  network_interfaces {
    security_groups = [aws_security_group.web_sg.id]
  }
}

resource "aws_autoscaling_group" "web_asg" {
  vpc_zone_identifier = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  target_group_arns   = [aws_lb_target_group.web_tg.arn]
  desired_capacity    = 2
  min_size            = 2
  max_size            = 4

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
}


resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  network_interfaces {
    security_groups = [aws_security_group.app_sg.id]
  }
}

resource "aws_autoscaling_group" "app_asg" {
  vpc_zone_identifier = [aws_subnet.private_app_1.id, aws_subnet.private_app_2.id]
  target_group_arns   = [aws_lb_target_group.app_tg.arn]
  desired_capacity    = 2
  min_size            = 2
  max_size            = 4

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
}