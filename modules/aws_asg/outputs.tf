
output "load_balancer_dns_name" {
  value = aws_lb.eni_lb.dns_name
}

output "load_balancer_arn" {
  value = aws_lb.eni_lb.arn
}


output "target_group_arn" {
  value = aws_lb_target_group.eni_tg.arn
}
