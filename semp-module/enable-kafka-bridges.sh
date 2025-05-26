create_kafka_bridge() {
    local broker=${1}
    local sender=${1}"-sender"
    local receiver=${1}"-receiver"

    local queue_suffix=${2}
    local local_topic="bridge/$broker/solace"
    local remote_topic="from.solace"

    queue="TO-"$queue_suffix
    create_queue $queue
    create_queue_subscription $queue $local_topic
    create_queue_subscription $queue "acmebank/customer/*/*"
            
    printf "Creating Kafka sender...  "
    post_semp2  "/kafkaSenders" \
                '{
                    "bootstrapAddressList": "'$broker'",
                    "enabled": true,
                    "kafkaSenderName": "'$sender'"
                }'
            
    sleep 1
    printf "Creating queue bindings...  "
    post_semp2  "/kafkaSenders/$sender/queueBindings" \
                '{
                    "ackMode": "all",
                    "enabled": true,
                    "kafkaSenderName": "'$sender'",
                    "partitionConsistentHash": "crc",
                    "partitionExplicitNumber": 0,
                    "partitionRandomFallbackEnabled": true,
                    "partitionScheme": "consistent",
                    "queueName": "'$queue'",
                    "remoteTopic": "from.solace"
                }'

    queue="FROM-"$queue_suffix
    create_queue $queue
    create_queue_subscription $queue $local_topic

    printf "Creating Kafka receiver...  "
    post_semp2  "/kafkaReceivers" \
                '{
                    "bootstrapAddressList": "'$broker'",
                    "enabled": true,
                    "kafkaReceiverName": "'$receiver'"
                }'

    printf "Creating topic binding...  "
    post_semp2  "/kafkaReceivers/$receiver/topicBindings" \
                '{
                    "enabled": true,
                    "initialOffset": "end",
                    "kafkaReceiverName": "'$receiver'",
                    "localTopic": "'$local_topic'",
                    "topicName": "to.solace"
                }'
    echo
}

create_kafka_bridge "redpanda" "KAFKA"
