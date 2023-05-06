# AWS Autoscaling Group with Load Balancer Module


## Outcome
![Screenshot from 2023-05-06 12-56-32](https://user-images.githubusercontent.com/58726365/236625421-1095f01f-3994-4421-81e6-ff238ee8cb99.png)

This Terraform module provisions an Autoscaling Group (ASG) with a Load Balancer on AWS. The module creates the following resources:
- Autoscaling Group
- Load Balancer
- Target Group
- Security Group
- Listener

## Usage

1. Clone this repository:

git clone https://github.com/eniolastyle/terraform-one.git

2. Change into the project directory:

cd terraform-one

3. Create main terraform config file:

```terrafrom 
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

```

## Inputs


| Variable   | Description                                      | Type   |  | Default | Required  |
| ---------- | ------------------------------------------------ | ------ |  | n/a     | yes       |
| name_prefix | Prefix to identify resources                                | string | | n/a     | yes       |
| image_id | ID of the AMI to use for the instances                             | string |  | n/a     | yes       |
| instance_type     | Instance type to launch    | string | | n/a     | yes       |
| key_name   | Name of the key pair to use for the instances | string |  | n/a     | yes       |
| security_group_id | Name of the key pair to use for the instances           | list | | n/a     | yes       |
| user_data | Name of the key pair to use for the instances        | string |
| security_group_id | 	ID of the VPC to launch the instances in         | string |
| health_path | 	The URL path used to check the health of the instances           | string |
| subnets_id |	List of subnet IDs to launch the instances in         | string |
| max_size | 		Maximum number of instances in the ASG         | string |
| min_size | Minimum number of instances in the ASG         | string |
| desired_capacity | Desired number of instances in the ASG         | string |
| listener |	Object that defines the listener configuration for the Load Balancer          | string |
| tags | 	Object that defines the listener configuration for the Load Balancer         | string |
| vpc_id | vpc_id                               | string | | n/a     | yes       |

## Outputs


| Variable   | Description                                      | 
| ---------- | ------------------------------------------------ | 
| autoscaling_group_id | 	ID of the Autoscaling Group created by the module                   |
| load_balancer_arn | ARN of the Load Balancer created by the module            |
| load_balancer_dns     | DNS name of the Load Bal   | 

If you have any further clarification, kindly reach out to me with the below information.

## Author

Lawal Eniola Abdullateef  
Twitter: [@eniolaamiola\_](https://twitter.com/eniolaamiola_)
