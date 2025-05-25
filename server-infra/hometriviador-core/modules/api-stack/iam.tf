// DATA SOURCES --------------------------------------------
data "aws_iam_policy_document" "ecs_service_standard" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeTags",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_service_s3" {
  statement {
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::streamzen-*/*"
    ]
  }
}

data "aws_iam_policy_document" "vpce_ecs_service_s3" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    effect = "Allow"
    actions = [
      "*"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "ecs_service_scaling" {
  statement {
    effect = "Allow"
    actions = [
      "application-autoscaling:*",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
      "iam:CreateServiceLinkedRole",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_service_install" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeImageScanFindings",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:ListTagsForResource",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
}
// ----------------------------------------------------------

resource "aws_iam_role" "ecs_service" {
  name = "ecs-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role" "ecs_service_install" {
  name = "ecs-service-install-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ecs-tasks.amazonaws.com",
            "ecs.amazonaws.com"
          ]
        }
      },
    ]
  })
}

resource "aws_iam_policy" "ecs_service_standard" {
  name        = "ecs-standard-policy"
  path        = "/"
  description = "Allow standard ecs actions"
  policy      = data.aws_iam_policy_document.ecs_service_standard.json
}

resource "aws_iam_policy" "ecs_service_s3" {
  name        = "ecs-s3-policy"
  path        = "/"
  description = "Allow S3 upload for ecs service"
  policy      = data.aws_iam_policy_document.ecs_service_s3.json
}

resource "aws_iam_policy" "ecs_service_scaling" {
  name        = "ecs-scaling-policy"
  path        = "/"
  description = "Allow ecs service scaling"
  policy      = data.aws_iam_policy_document.ecs_service_scaling.json
}

resource "aws_iam_role_policy_attachment" "ecs_service_standard" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = aws_iam_policy.ecs_service_standard.arn
}

resource "aws_iam_role_policy_attachment" "ecs_service_s3" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = aws_iam_policy.ecs_service_s3.arn
}

resource "aws_iam_role_policy_attachment" "ecs_service_scaling" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = aws_iam_policy.ecs_service_scaling.arn
}

resource "aws_iam_policy" "ecs_service_install" {
  name        = "ecs_service_install"
  path        = "/"
  description = "Allow access to ecr for pulling image"
  policy      = data.aws_iam_policy_document.ecs_service_install.json
}

resource "aws_iam_role_policy_attachment" "ecs_service_install" {
  role       = aws_iam_role.ecs_service_install.name
  policy_arn = aws_iam_policy.ecs_service_install.arn
}
