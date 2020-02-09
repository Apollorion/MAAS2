resource "aws_iam_role" "scraper" {
  name = "maas2_scraper"

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

resource "aws_iam_role_policy_attachment" "scraper" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.scraper.name
}

resource "aws_lambda_function" "scraper" {
  filename      = "../compiled/scraper_payload.zip"
  function_name = "maas2_scraper"
  role          = aws_iam_role.scraper.arn
  handler       = "handler.handler"
  source_code_hash = filebase64sha256("../compiled/scraper_payload.zip")
  timeout = 500

  runtime = "nodejs12.x"

  environment {
    variables = {
      mysqlHost = var.mysqlHost
      mysqlUser = var.mysqlUser
      mysqlPass = var.mysqlPass
      mysqlDB = var.mysqlDB
    }
  }
}

resource "aws_cloudwatch_event_rule" "run_scraper" {
  name        = "run_scraper"
  description = "runs the maas2 scraper function"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "run_scraper" {
  rule = aws_cloudwatch_event_rule.run_scraper.name
  target_id = "run_lambda_maas2_scraper"
  arn = aws_lambda_function.scraper.arn
}

resource "aws_lambda_permission" "run_scraper" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scraper.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.run_scraper.arn
}