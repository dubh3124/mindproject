#resource "aws_codedeploy_app" "this" {
#  compute_platform = "ECS"
#  name = "nlpbackend-${local.full_name}"
#}
#
#resource "aws_codedeploy_deployment_group" "nlpdeploygroup" {
#  app_name              = aws_codedeploy_app.this.name
#  deployment_group_name = "nlp-${local.full_name}"
#  service_role_arn      = ""
#
#  auto_rollback_configuration {
#    enabled = true
#    events = ["DEPLOYMENT_FAILURE"]
#  }
#
#  blue_green_deployment_config {
#    deployment_ready_option {
#      action_on_timeout = "CONTINUE_DEPLOYMENT"
#      wait_time_in_minutes = 1
#    }
#
#    terminate_blue_instances_on_deployment_success {
#      action = "TERMINATE"
#      termination_wait_time_in_minutes = 1
#    }
#  }
#
#  deployment_style {
#    deployment_option = "WITH_TRAFFIC_CONTROL"
#    deployment_type = "BLUE_GREEN"
#  }
#
#  ecs_service {
#    cluster_name = data.terraform_remote_state.nlpappinfra.ecs_cluster["name"]
#    service_name = data.terraform_remote_state.nlpappinfra.ecs_service["name"]
#  }
#
#  load_balancer_info {
#    target_group_pair_info {
#      prod_traffic_route {
#        listener_arns = []
#      }
#      target_group {
#        name = ""
#      }
#    }
#  }
#
#}
#
