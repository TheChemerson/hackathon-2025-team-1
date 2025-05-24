### Init

queue="CONN-MGMT-MONGODB"

create_queue $queue

### Sink

queue="FROM-MONGODB"

create_queue $queue
create_queue_subscription $queue "cdc/mongo/static/topic"
create_queue_subscription $queue "cdc/mongo/dynamic/>"

echo
