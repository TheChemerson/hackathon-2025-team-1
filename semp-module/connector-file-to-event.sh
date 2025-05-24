queue="CONN-FILE-EVENTS"
create_queue $queue
create_queue_subscription $queue "solace/fc/event/dynamic/*/*/*"

queue="$queue-LVQ"
create_queue $queue 0
create_queue_subscription $queue "solace/fc/event/checkpoint"
create_queue_subscription $queue "solace/fc/event/dynamic/*/*/*"

echo