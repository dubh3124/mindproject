output "alb_url" {
  value = "http://${aws_alb.nlpapp-lb.dns_name}"
}

output "ecs_cluster" {
  value = aws_ecs_cluster.nlpcluster
}

output "ecs_service" {
  value = aws_ecs_service.app
}