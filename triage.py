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


def handler(event, context):
    import boto3

    category = classify(event["message"])
    item = {
        "ticket_id": event["ticket_id"],
        "message": event["message"],
        "category": category,
    }
    table = boto3.resource("dynamodb").Table(os.environ["TABLE_NAME"])
    table.put_item(Item=item)
    return item
