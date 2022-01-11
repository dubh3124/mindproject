resource "aws_codebuild_project" "bootstrap" {
  name           = "bootstrapper-${local.full_name}"
  service_role   = aws_iam_role.bootstrapper.arn
  build_timeout  = 15

  artifacts {
    encryption_disabled    = false
    location               = aws_s3_bucket.nlppipeline.bucket
    name                   = "bootstrap.zip"
    override_artifact_name = false
    packaging              = "ZIP"
    type                   = "S3"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
      group_name = aws_cloudwatch_log_group.bootstrapper.name
      stream_name = aws_cloudwatch_log_stream.bootstrapper.name
    }
  }

  source {
    buildspec           = templatefile("bootstrapper_buildspec.yml", {})
    location            = var.repo_location
    type                = "GITHUB"

  }
}

resource "aws_iam_role" "bootstrapper" {
  name = "bootstrapper-role-${local.full_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "bootstrapper-s3access" {
  role   = aws_iam_role.bootstrapper.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "pipelinebucketaccess",
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject"
        ],
        "Resource": [
          aws_s3_bucket.nlppipeline.arn,
          "${aws_s3_bucket.nlppipeline.arn}/*"
        ]
      },
      {
        "Sid": "logging",
        "Effect": "Allow",
        "Action": [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ],
        "Resource": [
          "${aws_cloudwatch_log_stream.bootstrapper.arn}/*"
        ]
      }
    ]
  })
}


resource "aws_codebuild_project" "nlpcodebuild" {
  name         = "codebuild-${local.full_name}"
  service_role = aws_iam_role.imagebuilder.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type         = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "APP_NAME"
      value = "ecr-nlpappp-dev"
    }
  }

    logs_config {
    cloudwatch_logs {
      status = "ENABLED"
      group_name = aws_cloudwatch_log_group.imagebuilder.name
      stream_name = aws_cloudwatch_log_stream.imagebuilder.name
    }
  }


  source {
    type = "CODEPIPELINE"
    buildspec = "nlpapp/buildspec.yml"
  }
}

resource "aws_iam_role_policy" "imagebuilder" {
  role   = aws_iam_role.imagebuilder.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "pipelinebucketaccess",
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject"
        ],
        "Resource": [
          aws_s3_bucket.nlppipeline.arn,
          "${aws_s3_bucket.nlppipeline.arn}/*"
        ]
      },
      {
        "Sid": "logging",
        "Effect": "Allow",
        "Action": [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ],
        "Resource": [
          "${aws_cloudwatch_log_stream.imagebuilder.arn}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:DescribeRepositories"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:UploadLayerPart",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability"
        ],
        "Resource" : [
          data.terraform_remote_state.nlpappinfra.outputs.ecr_repo["arn"],
          "arn:aws:ecr:us-east-1:166531731337:repository/python"
        ]
      }

    ]
  })
}


resource "aws_iam_role" "imagebuilder" {
  name = "imagebuilder-role-${local.full_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy" "ECSPowerUser" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "ECSPowerUserRole" {
  policy_arn = data.aws_iam_policy.ECSPowerUser.arn
  role       = aws_iam_role.imagebuilder.name
}