resource "aws_cloudwatch_event_rule" "pipeline" {
  name          = "pipelinekickoff-${local.full_name}"
  event_pattern = jsonencode({
    "source" : [
      "aws.codebuild"
    ],
    "detail-type" : [
      "CodeBuild Build State Change"
    ],
    "detail" : {
      "build-status": [
        "SUCCEEDED"
      ],
      "project-name": [
        "${aws_codebuild_project.bootstrap.name}"
      ]
    }
  })
}