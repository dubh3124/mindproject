resource "aws_ecs_service" "app" {
  name = "ecsservice-${local.full_name}"
  launch_type = "FARGATE"
  task_definition = aws_ecs_task_definition.nlptaskdef.arn
  desired_count = 2
  cluster = aws_ecs_cluster.nlpcluster.id
  load_balancer {
    target_group_arn = aws_lb_target_group.nlpapptg.arn
    container_name = "nlpapp"
    container_port = local.api_port
  }
  network_configuration {
    assign_public_ip = false
    security_groups = [aws_security_group.egress_all.id, aws_security_group.http.id, aws_security_group.ingress_api.id]
    subnets = data.terraform_remote_state.nlpnetwork.outputs.private-subnets
  }
}
