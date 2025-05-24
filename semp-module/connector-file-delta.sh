### Init

queue="CONN-FILE-DELTA"
create_queue $queue
create_queue_subscription $queue "solace/fcd/source"
create_queue_subscription $queue "solace/fcd/source/file/*"

queue="$queue-LVQ"
create_queue $queue 0
create_queue_subscription $queue "solace/fcd/source/checkpoint"

# ### Source
# create_queue "CONN-MGMT-FILE-DELTA-SOURCE"

# ### Sink
# create_queue "CONN-MGMT-FILE-DELTA-SINK"

echo