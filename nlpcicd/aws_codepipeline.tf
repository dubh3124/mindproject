resource "aws_codepipeline" "nlpapppipeline" {
  name     = "pipeline-${local.full_name}"
  role_arn = aws_iam_role.pipeline.arn
  artifact_store {
    location = aws_s3_bucket.nlppipeline.bucket
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      category = "Source"
      name     = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"
      output_artifacts = ["source"]
      configuration = {
        PollForSourceChanges = false
        S3Bucket = aws_s3_bucket.nlppipeline.bucket
        S3ObjectKey = aws_codebuild_project.bootstrap.artifacts.0.name
      }
    }
  }
  stage {
    name = "Build"
    action {
      category = "Build"
      name     = "Build"
      provider = "CodeBuild"
      input_artifacts = ["source"]
      output_artifacts = ["build"]
      version  = "1"
      owner = "AWS"
      configuration = {
        ProjectName = aws_codebuild_project.nlpcodebuild.name
      }
    }
  }
  stage {
    name = "Deploy"
    action {
      category = "Deploy"
      name     = "Deploy"
      owner    = "AWS"
      input_artifacts = ["build"]
      provider = "ECS"
      version  = "1"
      configuration = {
        ClusterName = data.terraform_remote_state.nlpappinfra.outputs.ecs_cluster["name"]
        ServiceName = data.terraform_remote_state.nlpappinfra.outputs.ecs_service["name"]
      }
    }
  }
}

resource "aws_iam_role" "pipeline" {
  name = "pipeline-role-${local.full_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "pipeline-s3access" {
  role   = aws_iam_role.pipeline.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "pipelinebucketaccess",
        "Effect": "Allow",
        "Action": [
          "s3:PutObject*",
          "s3:Get*"
        ],
        "Resource": [
          aws_s3_bucket.nlppipeline.arn,
          "${aws_s3_bucket.nlppipeline.arn}/*"
        ]
      },
      {
        "Sid": "codebuildjobs",
        "Effect": "Allow",
        "Action": [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ],
        "Resource": [
          aws_codebuild_project.nlpcodebuild.arn
        ]
      },
      {
          "Action": [
              "codedeploy:CreateDeployment",
              "codedeploy:GetDeployment",
              "codedeploy:GetApplication",
              "codedeploy:GetApplicationRevision",
              "codedeploy:RegisterApplicationRevision",
              "codedeploy:GetDeploymentConfig",
              "ecs:*"
          ],
          "Resource": "*",
          "Effect": "Allow"
      },
      {
          "Action": [
              "iam:PassRole"
          ],
          "Resource": "*",
          "Effect": "Allow",
          "Condition": {
              "StringEqualsIfExists": {
                  "iam:PassedToService": [
                      "ecs-tasks.amazonaws.com"
                  ]
              }
          }
      },

    ]
  })
}


resource "aws_iam_role" "cloudwatchpipeline" {
  name = "pipeline-event-role-${local.full_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "eventpipelinekickoff" {
  role   = aws_iam_role.cloudwatchpipeline.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Sid": "pipelinekickoff",
      "Effect": "Allow",
      "Action": [
        "codepipeline:StartPipelineExecution",
      ],
      "Resource": [
        aws_codepipeline.nlpapppipeline.arn
      ]
    }]
  })
}
