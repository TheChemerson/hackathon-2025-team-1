### Init

queue="CONN-MGMT-MQ"

create_queue $queue

### Source

queue="TO-MQ"

create_queue $queue
create_queue_subscription $queue "connector/solace/mq"
create_queue_subscription $queue "acmebank/insurance/policy/*/*"

### Sink

queue="FROM-MQ"

create_queue $queue
create_queue_subscription $queue "connector/mq/solace"

echo
