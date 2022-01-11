resource "aws_cloudwatch_event_target" "pipelinekickoff" {
  target_id = "pipelineeventtarget-${local.full_name}"
  rule = aws_cloudwatch_event_rule.pipeline.name
  arn = aws_codepipeline.nlpapppipeline.arn
  role_arn = aws_iam_role.cloudwatchpipeline.arn
}