resource "aws_iam_role" "api" {
  name = "maas2_api"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "api" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.api.name
}

resource "aws_iam_role_policy_attachment" "api_vpc_access" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role = aws_iam_role.api.name
}

resource "aws_lambda_function" "api" {
  filename      = "../compiled/api_payload.zip"
  function_name = "maas2_api"
  role          = aws_iam_role.api.arn
  handler       = "handler.handler"
  source_code_hash = filebase64sha256("../compiled/api_payload.zip")
  timeout = 10

  runtime = "nodejs12.x"

  environment {
    variables = {
      mysqlHost = var.mysqlHost
      mysqlUser = var.mysqlUser
      mysqlPass = var.mysqlPass
      mysqlDB = var.mysqlDB
    }
  }

  vpc_config {
    security_group_ids = var.securityGroupIds
    subnet_ids = var.subnetIds
  }
}