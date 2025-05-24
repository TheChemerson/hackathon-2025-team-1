### Init

queue="CONN-FILE"
create_queue $queue
create_queue_subscription $queue "solace/fc/source/base"
create_queue_subscription $queue "solace/fc/source/base/file/*"

queue="$queue-LVQ"
create_queue $queue 0
create_queue_subscription $queue "solace/fc/source/checkpoint"

### Source

create_queue "CONN-MGMT-FILE-SOURCE"

### Sink

create_queue "CONN-MGMT-FILE-SINK"

echo
