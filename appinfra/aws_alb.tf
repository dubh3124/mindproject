resource "aws_lb_target_group" "nlpapptg" {
  name        = "targetgroup-${local.full_name}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.nlpnetwork.outputs.vpcid

  health_check {
    enabled = true
    path    = "/"
  }
}

resource "aws_alb" "nlpapp-lb" {
  name               = "lb-${local.full_name}"
  internal           = false
  load_balancer_type = "application"

  subnets = data.terraform_remote_state.nlpnetwork.outputs.public-subnets

  security_groups = [
    aws_security_group.http.id,
#    aws_security_group.https.id,
    aws_security_group.egress_all.id,
  ]
}

resource "aws_alb_listener" "sun_api_http" {
  load_balancer_arn = aws_alb.nlpapp-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlpapptg.arn
  }
}
