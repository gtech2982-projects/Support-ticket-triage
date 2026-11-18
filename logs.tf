resource "aws_cloudwatch_log_group" "triage" {
  name              = "/aws/lambda/support-ticket-triage"
  retention_in_days = 7
}