data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "apache_data_script" {
  template = file("./user-data.tpl")
  vars = {
    server = "apache2"
  }
}

module "basic_security_group" {
  source      = "./modules/aws_sg"
  name_prefix = var.name_prefix
}

module "aws_autoscaling_group" {
  source            = "./modules/aws_asg"
  name_prefix       = var.name_prefix
  image_id          = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type
  key_name          = var.key_name
  security_group_id = [module.basic_security_group.security_group_id]
  user_data         = base64encode(data.template_file.apache_data_script.rendered)
  vpc_id            = data.aws_vpc.default_vpc.id
  health_path       = var.health_path
  subnets_id        = data.aws_subnets.subnets.ids
  max_size          = var.max_size
  min_size          = var.min_size
  desired_capacity  = var.desired_capacity
  traffic_port      = var.traffic_port
  protocol          = var.protocol
  target_type       = var.target_type
}

module "listener" {
  source            = "./modules/aws_listener"
  load_balancer_arn = module.aws_autoscaling_group.load_balancer_arn
  traffic_port      = var.traffic_port
  protocol          = var.protocol
  action_type       = var.action_type
  target_group_arn  = module.aws_autoscaling_group.target_group_arn
}
