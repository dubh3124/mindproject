output "alb_url" {
  value = "http://${aws_alb.nlpapp-lb.dns_name}"
}