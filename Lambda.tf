data "archive_file" "triage" {
  type        = "zip"
  source_file = "${path.module}/triage.py"
  output_path = "${path.module}/build/triage.zip"
}

resource "aws_lambda_function" "triage" {
  function_name = "support-ticket-triage"
  role          = aws_iam_role.triage.arn
  runtime       = "python3.12"
  handler       = "triage.handler"
  filename         = data.archive_file.triage.output_path
  source_code_hash = data.archive_file.triage.output_base64sha256

  memory_size = 128
  timeout     = 5

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.tickets.name
    }
  }

  depends_on = [aws_cloudwatch_log_group.triage]
}