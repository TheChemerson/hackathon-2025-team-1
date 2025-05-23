docker exec -it redpanda rpk topic create from_solace -c retention.ms=3600000
docker exec -it redpanda rpk topic create to_solace -c retention.ms=3600000