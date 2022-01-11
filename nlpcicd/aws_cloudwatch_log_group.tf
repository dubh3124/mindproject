resource "aws_cloudwatch_log_group" "bootstrapper" {
  name = "/aws/codebuild/bootstrapper-${local.full_name}"
}

resource "aws_cloudwatch_log_group" "imagebuilder" {
  name = "/aws/codebuild/imagebuilder-${local.full_name}"
}