### Init

queue="CONN-MGMT-TIBCO"

create_queue $queue

### Source

queue="TO-TIBCO"

create_queue $queue
create_queue_subscription $queue "connector/solace/tibco"

### Sink

queue="FROM-TIBCO"

create_queue $queue
create_queue_subscription $queue "connector/tibco/solace"
