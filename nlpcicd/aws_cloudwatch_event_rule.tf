resource "aws_cloudwatch_event_rule" "pipeline" {
  name          = "pipelinekickoff-${local.full_name}"
  event_pattern = jsonencode({
    "source" : [
      "aws.s3"
    ],
    "detail-type" : [
      "AWS API Call via CloudTrail"
    ],
    "detail" : {
      "eventSource" : [
        "s3.amazonaws.com"
      ],
      "eventName" : [
        "PutObject",
        "CompleteMultipartUpload",
        "CopyObject"
      ],
      "requestParameters" : {
        "bucketName" : [
          aws_s3_bucket.nlppipeline.bucket
        ],
        "key" : [
          aws_codebuild_project.bootstrap.artifacts.0.name
        ]
      }
    }
  })
}