queue="RETAIL-AUDIT"
create_queue $queue
create_queue_subscription $queue "Retail/Order/>"

queue="RETAIL-STOCK"
create_queue $queue
create_queue_subscription $queue "Retail/Order/v1/Canceled/>"
create_queue_subscription $queue "Retail/Order/v1/Paid/>"

queue="RETAIL-FULFILLMENT"
create_queue $queue
create_queue_subscription $queue "Retail/Order/v1/Canceled/>"
create_queue_subscription $queue "Retail/Order/v1/Paid/>"

queue="RETAIL-NOTIFICATION"
create_queue $queue
create_queue_subscription $queue "Retail/Order/v1/Canceled/>"
create_queue_subscription $queue "Retail/Order/v1/Confirmed/>"
create_queue_subscription $queue "Retail/Order/v1/Shipped/>"