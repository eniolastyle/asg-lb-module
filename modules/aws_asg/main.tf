
resource "aws_launch_template" "eni_lt" {
  name                   = "${var.name_prefix}-lt"
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_id
  user_data              = var.user_data

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-lt"
    }
  }
}

resource "aws_lb_target_group" "eni_tg" {
  name        = "${var.name_prefix}-tg"
  port        = var.traffic_port
  protocol    = var.protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id

  health_check {
    path                = var.health_path
    port                = var.traffic_port
    protocol            = var.protocol
    matcher             = "200-399"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    enabled             = true
  }
}

resource "aws_lb" "eni_lb" {
  name               = "${var.name_prefix}-lb"
  ip_address_type    = "ipv4"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_id
  subnets            = var.subnets_id
}

resource "aws_autoscaling_group" "terraform-one-asg" {
  name                      = "${var.name_prefix}-asg"
  vpc_zone_identifier       = var.subnets_id
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.eni_tg.arn]

  launch_template {
    id      = aws_launch_template.eni_lt.id
    version = "$Latest"
  }
}









