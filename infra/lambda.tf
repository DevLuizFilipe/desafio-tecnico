resource "aws_iam_role" "lambda_role" {
  name = "${var.app_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.app_name}-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = "arn:aws:s3:::${var.bucket_name}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["logs:*"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_eventbridge_rule.daily_rule.arn
}

resource "aws_lambda_function" "lambda" {
  function_name = "${var.app_name}-daily-writer"
  role          = aws_iam_role.lambda_role.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"
  timeout       = 30

  filename         = "${path.module}/lambda/function.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/function.zip")

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }
}

resource "aws_eventbridge_rule" "daily_rule" {
  name                = "${var.app_name}-daily-rule"
  description         = "Executa o Lambda diariamente às 10:00 horário de São Paulo (13:00 UTC)"
  schedule_expression = "cron(0 13 * * ? *)"
}

resource "aws_eventbridge_target" "lambda_target" {
  rule      = aws_eventbridge_rule.daily_rule.name
  target_id = "lambda-target"
  arn       = lambda_arn.value
}
