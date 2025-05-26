### Init

queue="CONN-MGMT-TIBCO"

create_queue $queue

### Source

queue="TO-TIBCO"

create_queue $queue
create_queue_subscription $queue "connector/solace/tibco"
create_queue_subscription $queue "acmebank/solace/core/payment/*/paid/v1/>"

### Sink

queue="FROM-TIBCO"

create_queue $queue
create_queue_subscription $queue "connector/tibco/solace"
