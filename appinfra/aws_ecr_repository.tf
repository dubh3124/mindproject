resource "aws_ecr_repository" "ecr-nlpapp" {
  name                 = "ecr-${local.full_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}