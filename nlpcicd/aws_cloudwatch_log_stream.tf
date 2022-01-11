resource "aws_cloudwatch_log_stream" "bootstrapper" {
  log_group_name = aws_cloudwatch_log_group.bootstrapper.name
  name           = "boostraper-${local.full_name}"
}

resource "aws_cloudwatch_log_stream" "imagebuilder" {
  log_group_name = aws_cloudwatch_log_group.imagebuilder.name
  name           = "imagebuilder-${local.full_name}"
}