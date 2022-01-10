resource "aws_ecs_cluster" "nlpcluster" {
  name = "ecscluster-${local.full_name}"
  capacity_providers = ["FARGATE"]
}