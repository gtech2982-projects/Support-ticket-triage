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
    category = classify(event["message"])
    return {
        "ticket_id": event["ticket_id"],
        "message": event["message"],
        "category": category,
    }