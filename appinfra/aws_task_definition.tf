resource "aws_ecs_task_definition" "nlptaskdef" {
  family                = "taskdef-${local.full_name}"
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.nlpapp-task-execution-role.arn
  volume {
    name = "my-vol"
  }
  requires_compatibilities = ["FARGATE"]
  cpu = 256
  memory = 512
  container_definitions = jsonencode([
    {
      name = "nlpapp"
      essential = true
      image = "httpd:2.4"
      mountPoints = [{
        containerPath = "/usr/local/apache2/htdocs"
        sourceVolume = "my-vol"
      }]
      portMappings = [{
        containerPort = 80
        hostport = 80
      }]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-region = "us-east-1",
          awslogs-group = aws_cloudwatch_log_group.nlpapp.name
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    {
      name = "datastore"
      essential = false
      image = "busybox"
      command = ["/bin/sh -c \"while true; do echo '<html><head><title>Amazon ECS Sample App</title></head><body><div><h1>Amazon ECS Sample App</h1><h2>Congratulations! </h2><p>Your application is now running on a container in Amazon ECS.</p>' > top; /bin/date > date ; hostname -i > ipaddr; echo '</div></body></html>' > bottom; cat top date bottom ipaddr > /usr/local/apache2/htdocs/index.html ; sleep 1; done\""]
      entryPoint = ["sh", "-c"]
      volumesFrom = [{
        sourceContainer = "nlpapp"
      }]
    }
  ])
}

