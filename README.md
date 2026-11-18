# Support ticket triage

Serverless support-ticket triage in AWS region `ap-south-1` (Mumbai).

A ticket arrives at the API. Python 3.12 assigns a category and stores the ticket in DynamoDB. You pay only when a ticket is sent. Logs are kept for 7 days. `terraform destroy` removes everything this project creates.

## Categories

- `network` for internet, wifi, outage, or slow
- `billing` for bill, payment, charge, invoice, or refund
- `account` for password, login, or locked
- `general` for anything else

## Send a ticket

```powershell
Invoke-RestMethod -Method Post -Uri "https://brgbbar6zh.execute-api.ap-south-1.amazonaws.com/tickets" -ContentType "application/json" -Body '{"ticket_id":"T-1001","message":"my wifi is slow"}'
```

The reply shows `ticket_id`, `message`, and `category`.

## Remove it

From the project folder, run `terraform destroy` and type `yes` only when the preview lists resources from this project.
