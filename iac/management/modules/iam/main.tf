resource "aws_iam_policy" "user_restricted_policy_lambda" {
  name        = "UserRestrictedPolicyLambda"
  description = "Policy to restrict users to their own resources"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lambda:ListFunctions",
        "lambda:GetFunction",
        "lambda:InvokeFunction"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:CreateFunction",
        "lambda:UpdateFunctionCode",
        "lambda:DeleteFunction"
      ],
      "Resource": "arn:aws:lambda:eu-west-1:087559609246:function/*",
      "Condition": {
        "StringEquals": {
          "lambda:ResourceTag/Owner": "$${{aws:username}}"
        }
      }
    }
  ]
}
)
}


resource "aws_iam_policy" "user_restricted_policy_athena" {
  name        = "UserRestrictedPolicyAthena"
  description = "Policy to restrict users to their own resources on Athena"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "athena:StartQueryExecution",
        "athena:GetQueryResults"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "athena:CreateNamedQuery",
        "athena:DeleteNamedQuery",
      ],
      "Resource": "arn:aws:athena:eu-west-1:087559609246:workgroup/*",
      "Condition": {
        "StringEquals": {
          "athena:ResourceTag/Owner": "$${{aws:username}}"
        }
      }
    }
  ]
}

)
}

resource "aws_iam_policy" "user_restricted_policy_s3" {
  name        = "UserRestrictedPolicyS3"
  description = "Policy to restrict users to their own resources on S3"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::$${{aws:username}}*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::*",
      "Condition": {
        "StringEquals": {
          "s3:ResourceTag/Owner": "$${{aws:username}}"
        }
      }
    }
  ]
}

)
}

resource "aws_iam_policy" "user_restricted_policy_eventbridge" {
  name        = "UserRestrictedPolicyEventbridge"
  description = "Policy to restrict users to their own resources on Eventbridge"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "events:ListRules",
        "events:DescribeRule",
        "events:PutRule",
        "events:DeleteRule"
      ],
      "Resource": "arn:aws:events:eu-west-1:087559609246:rule/*",
      "Condition": {
        "StringEquals": {
          "events:ResourceTag/Owner": "$${{aws:username}}"
        }
      }
    }
  ]
}

)
}

resource "aws_iam_policy" "user_restricted_policy_dynamodb" {
  name        = "UserRestrictedPolicyDynamoDB"
  description = "Policy to restrict users to their own resources on DynamoDB"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:ListTables",
        "dynamodb:DescribeTable"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "arn:aws:dynamodb:eu-west-1:087559609246:table/*",
      "Condition": {
        "StringEquals": {
          "dynamodb:ResourceTag/Owner": "$${{aws:username}}"
        }
      }
    }
  ]
}
)
}

resource "aws_iam_policy" "user_restricted_policy_cicd" {
  name        = "UserRestrictedPolicyCICD"
  description = "Policy to restrict users to their own CICD resources"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:ListProjects",
        "codepipeline:ListPipelines"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:StartBuild",
        "codebuild:BatchGetBuilds",
        "codepipeline:StartPipelineExecution",
        "codepipeline:GetPipelineExecution"
      ],
      "Resource": [
        "arn:aws:codebuild:eu-west-1:087559609246:project/*",
        "arn:aws:codepipeline:eu-west-1:087559609246:pipeline/*"
      ],
      "Condition": {
        "StringEquals": {
          "codebuild:ResourceTag/Student": "$${{aws:username}}",
          "codepipeline:ResourceTag/Student": "$${{aws:username}}"
        }
      }
    }
  ]
}

)
}


resource "aws_iam_role" "restricted_user_role" {
  name = "restricted-user-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::087559609246:root"  # Adjust with your AWS account ID
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    "Environment" = "Conference"
  }
}

resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.restricted_user_role.name
  policy_arn = aws_iam_policy.user_restricted_policy_lambda.arn
}

resource "aws_iam_role_policy_attachment" "attach_athena_policy" {
  role       = aws_iam_role.restricted_user_role.name
  policy_arn = aws_iam_policy.user_restricted_policy_athena.arn
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.restricted_user_role.name
  policy_arn = aws_iam_policy.user_restricted_policy_s3.arn
}

resource "aws_iam_role_policy_attachment" "attach_eventbridge_policy" {
  role       = aws_iam_role.restricted_user_role.name
  policy_arn = aws_iam_policy.user_restricted_policy_eventbridge.arn
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy" {
  role       = aws_iam_role.restricted_user_role.name
  policy_arn = aws_iam_policy.user_restricted_policy_dynamodb.arn
}

resource "aws_iam_role_policy_attachment" "attach_cicd_policy" {
  role       = aws_iam_role.restricted_user_role.name
  policy_arn = aws_iam_policy.user_restricted_policy_cicd.arn
}