variable "load_balancer_arn" {
  type = string
}
variable "traffic_port" {
  type = number
}
variable "protocol" {
  type = string
}
variable "action_type" {
  type = string
}
variable "target_group_arn" {
  type = string
}

resource "aws_lb_listener" "eni_listener" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.traffic_port
  protocol          = var.protocol

  default_action {
    type             = var.action_type
    target_group_arn = var.target_group_arn
  }
}

output "listener_arn" {
  value = aws_lb_listener.eni_listener.arn
}
