import json
import os


def classify(message):
    text = message.lower()

    if any(word in text for word in ("internet", "wifi", "network", "outage", "slow")):
        return "network"
    if any(word in text for word in ("bill", "payment", "charge", "invoice", "refund")):
        return "billing"
    if any(word in text for word in ("password", "login", "account", "locked")):
        return "account"
    return "general"


def response(status_code, payload):
    return {
        "statusCode": status_code,
        "headers": {"content-type": "application/json"},
        "body": json.dumps(payload),
    }


def handler(event, context):
    import boto3

    if "body" in event:
        incoming = json.loads(event["body"] or "{}")
    else:
        incoming = event

    ticket_id = incoming.get("ticket_id")
    message = incoming.get("message")
    if not ticket_id or not message:
        return response(400, {"error": "ticket_id and message are required"})

    item = {
        "ticket_id": ticket_id,
        "message": message,
        "category": classify(message),
    }
    table = boto3.resource("dynamodb").Table(os.environ["TABLE_NAME"])
    table.put_item(Item=item)
    return response(200, item)
