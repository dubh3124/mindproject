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
      image = aws_ecr_repository.ecr-nlpapp.repository_url
      portMappings = [{
        containerPort = local.api_port
        hostport = local.api_port
      }]
      environment = [
        {
          name = "S3_UPLOAD_BUCKET"
          value = aws_s3_bucket.nlpappupload.bucket
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-region = var.region
          awslogs-group = aws_cloudwatch_log_group.nlpapp.name
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}