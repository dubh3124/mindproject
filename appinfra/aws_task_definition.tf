resource "aws_ecs_task_definition" "nlptaskdef" {
  family                = "taskdef-${local.full_name}"
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.nlpapp-task-execution-role.arn
  task_role_arn = aws_iam_role.nlpapp-task-role.arn
  requires_compatibilities = ["FARGATE"]
  cpu = 256
  memory = 512
  container_definitions = jsonencode([
    {
      name = "nlpapp"
      essential = true
      image = "166531731337.dkr.ecr.us-east-1.amazonaws.com/ecr-nlpappp-dev" #TODO: Variablize
      portMappings = [{
        containerPort = local.api_port
        hostport = local.api_port
      }]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-region = "us-east-1",
          awslogs-group = aws_cloudwatch_log_group.nlpapp.name
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}