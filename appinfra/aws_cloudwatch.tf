resource "aws_cloudwatch_log_group" "nlpapp" {
  name = "/ecs/${local.full_name}"
}

