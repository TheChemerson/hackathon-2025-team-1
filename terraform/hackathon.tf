# terraform {
#   required_providers {
#     solacebroker = {
#       source = "registry.terraform.io/solaceproducts/solacebroker"
#     }
#   }
# }

# variable "broker_url" {
#   type = string
#   description = "The URL of the Solace broker."
# }

# variable "broker_username" {
#   type = string
#   description = "The management username of the Solace broker."
# }

# variable "broker_password" {
#   type = string
#   description = "The management password of the Solace broker."
# }

# provider "solacebroker" {
#   url            = var.broker_url
#   username       = var.broker_username
#   password       = var.broker_password
# }


resource "solacebroker_msg_vpn" "default" {
  authentication_basic_type                               = "internal"
  dmr_enabled                                             = true
  enabled                                                 = true
  event_connection_count_threshold                        = {"clear_percent":60,"set_percent":80}
  event_egress_flow_count_threshold                       = {"clear_percent":60,"set_percent":80}
  event_egress_msg_rate_threshold                         = {"clear_value":3000000,"set_value":4000000}
  event_endpoint_count_threshold                          = {"clear_percent":60,"set_percent":80}
  event_ingress_flow_count_threshold                      = {"clear_percent":60,"set_percent":80}
  event_ingress_msg_rate_threshold                        = {"clear_value":3000000,"set_value":4000000}
  event_msg_spool_usage_threshold                         = {"clear_percent":60,"set_percent":80}
  event_service_amqp_connection_count_threshold           = {"clear_percent":60,"set_percent":80}
  event_service_mqtt_connection_count_threshold           = {"clear_percent":60,"set_percent":80}
  event_service_rest_incoming_connection_count_threshold  = {"clear_percent":60,"set_percent":80}
  event_service_smf_connection_count_threshold            = {"clear_percent":60,"set_percent":80}
  event_service_web_connection_count_threshold            = {"clear_percent":60,"set_percent":80}
  event_subscription_count_threshold                      = {"clear_percent":60,"set_percent":80}
  event_transacted_session_count_threshold                = {"clear_percent":60,"set_percent":80}
  event_transaction_count_threshold                       = {"clear_percent":60,"set_percent":80}
  jndi_enabled                                            = true
  max_connection_count                                    = 1000
  max_kafka_broker_connection_count                       = 300
  max_msg_spool_usage                                     = 15000
  max_transacted_session_count                            = 1000
  max_transaction_count                                   = 5000
  msg_vpn_name                                            = "default"
  replication_queue_max_msg_spool_usage                   = 1500
  semp_over_msg_bus_admin_client_enabled                  = true
  semp_over_msg_bus_admin_distributed_cache_enabled       = true
  semp_over_msg_bus_admin_enabled                         = true
  semp_over_msg_bus_show_enabled                          = true
  service_amqp_max_connection_count                       = 1000
  service_amqp_plain_text_enabled                         = true
  service_amqp_plain_text_listen_port                     = 5672
  service_amqp_tls_enabled                                = true
  service_amqp_tls_listen_port                            = 5671
  service_mqtt_max_connection_count                       = 1000
  service_mqtt_plain_text_enabled                         = true
  service_mqtt_plain_text_listen_port                     = 1883
  service_mqtt_tls_enabled                                = true
  service_mqtt_tls_listen_port                            = 8883
  service_mqtt_tls_web_socket_enabled                     = true
  service_mqtt_tls_web_socket_listen_port                 = 8443
  service_mqtt_web_socket_enabled                         = true
  service_mqtt_web_socket_listen_port                     = 8000
  service_rest_incoming_max_connection_count              = 1000
  service_rest_incoming_plain_text_enabled                = true
  service_rest_incoming_plain_text_listen_port            = 9000
  service_rest_incoming_tls_enabled                       = true
  service_rest_incoming_tls_listen_port                   = 9443
  service_rest_outgoing_max_connection_count              = 1000
  service_smf_max_connection_count                        = 1000
  service_web_max_connection_count                        = 1000

}

resource "solacebroker_msg_vpn_acl_profile" "default_acl-connector" {
  acl_profile_name                = "acl-connector"
  client_connect_default_action   = "allow"
  msg_vpn_name                    = solacebroker_msg_vpn.default.msg_vpn_name
  publish_topic_default_action    = "allow"
  subscribe_topic_default_action  = "allow"

}

resource "solacebroker_msg_vpn_acl_profile" "default_default" {
  acl_profile_name                = "default"
  client_connect_default_action   = "allow"
  msg_vpn_name                    = solacebroker_msg_vpn.default.msg_vpn_name
  publish_topic_default_action    = "allow"
  subscribe_topic_default_action  = "allow"

}

resource "solacebroker_msg_vpn_acl_profile" "default_read-only" {
  acl_profile_name                     = "read-only"
  client_connect_default_action        = "allow"
  msg_vpn_name                         = solacebroker_msg_vpn.default.msg_vpn_name
  subscribe_share_name_default_action  = "disallow"

}

resource "solacebroker_msg_vpn_client_profile" "default_client-connector" {
  allow_guaranteed_msg_receive_enabled                              = true
  allow_guaranteed_msg_send_enabled                                 = true
  client_profile_name                                               = "client-connector"
  event_client_provisioned_endpoint_spool_usage_threshold           = {"clear_percent":18,"set_percent":25}
  event_connection_count_per_client_username_threshold              = {"clear_percent":60,"set_percent":80}
  event_egress_flow_count_threshold                                 = {"clear_percent":60,"set_percent":80}
  event_endpoint_count_per_client_username_threshold                = {"clear_percent":60,"set_percent":80}
  event_ingress_flow_count_threshold                                = {"clear_percent":60,"set_percent":80}
  event_service_smf_connection_count_per_client_username_threshold  = {"clear_percent":60,"set_percent":80}
  event_service_web_connection_count_per_client_username_threshold  = {"clear_percent":60,"set_percent":80}
  event_subscription_count_threshold                                = {"clear_percent":60,"set_percent":80}
  event_transacted_session_count_threshold                          = {"clear_percent":60,"set_percent":80}
  event_transaction_count_threshold                                 = {"clear_percent":60,"set_percent":80}
  max_connection_count_per_client_username                          = 1000
  max_subscription_count                                            = 500000
  max_transaction_count                                             = 5000
  msg_vpn_name                                                      = solacebroker_msg_vpn.default.msg_vpn_name
  service_smf_max_connection_count_per_client_username              = 1000
  service_web_max_connection_count_per_client_username              = 1000

}

resource "solacebroker_msg_vpn_client_profile" "default_default" {
  allow_bridge_connections_enabled                                  = true
  allow_guaranteed_endpoint_create_enabled                          = true
  allow_guaranteed_msg_receive_enabled                              = true
  allow_guaranteed_msg_send_enabled                                 = true
  allow_shared_subscriptions_enabled                                = true
  allow_transacted_sessions_enabled                                 = true
  client_profile_name                                               = "default"
  event_client_provisioned_endpoint_spool_usage_threshold           = {"clear_percent":18,"set_percent":25}
  event_connection_count_per_client_username_threshold              = {"clear_percent":60,"set_percent":80}
  event_egress_flow_count_threshold                                 = {"clear_percent":60,"set_percent":80}
  event_endpoint_count_per_client_username_threshold                = {"clear_percent":60,"set_percent":80}
  event_ingress_flow_count_threshold                                = {"clear_percent":60,"set_percent":80}
  event_service_smf_connection_count_per_client_username_threshold  = {"clear_percent":60,"set_percent":80}
  event_service_web_connection_count_per_client_username_threshold  = {"clear_percent":60,"set_percent":80}
  event_subscription_count_threshold                                = {"clear_percent":60,"set_percent":80}
  event_transacted_session_count_threshold                          = {"clear_percent":60,"set_percent":80}
  event_transaction_count_threshold                                 = {"clear_percent":60,"set_percent":80}
  max_connection_count_per_client_username                          = 1000
  max_subscription_count                                            = 500000
  max_transaction_count                                             = 5000
  msg_vpn_name                                                      = solacebroker_msg_vpn.default.msg_vpn_name
  service_smf_max_connection_count_per_client_username              = 1000
  service_web_max_connection_count_per_client_username              = 1000

}

resource "solacebroker_msg_vpn_client_username" "default_connector" {
  acl_profile_name     = solacebroker_msg_vpn_acl_profile.default_acl-connector.acl_profile_name
  client_profile_name  = solacebroker_msg_vpn_client_profile.default_client-connector.client_profile_name
  client_username      = "connector"
  enabled              = true
  msg_vpn_name         = solacebroker_msg_vpn.default.msg_vpn_name

}

resource "solacebroker_msg_vpn_client_username" "default_default" {
  client_username  = "default"
  enabled          = true
  msg_vpn_name     = solacebroker_msg_vpn.default.msg_vpn_name

}

resource "solacebroker_msg_vpn_client_username" "default_healthcheck" {
  acl_profile_name  = solacebroker_msg_vpn_acl_profile.default_read-only.acl_profile_name
  client_username   = "healthcheck"
  enabled           = true
  msg_vpn_name      = solacebroker_msg_vpn.default.msg_vpn_name

}

resource "solacebroker_msg_vpn_client_username" "default_trace" {
  acl_profile_name     = "#telemetry-trace" # Note: This attribute may be system provisioned and a "depends_on" meta-argument may be required to the parent object of this attribute to ensure proper order of creation
  client_profile_name  = "#telemetry-trace" # Note: This attribute may be system provisioned and a "depends_on" meta-argument may be required to the parent object of this attribute to ensure proper order of creation
  client_username      = "trace"
  enabled              = true
  msg_vpn_name         = solacebroker_msg_vpn.default.msg_vpn_name

}

resource "solacebroker_msg_vpn_jndi_connection_factory" "default_-jms-cf-default" {
  connection_factory_name             = "/jms/cf/default"
  msg_vpn_name                        = solacebroker_msg_vpn.default.msg_vpn_name
  transport_direct_transport_enabled  = false
  xa_enabled                          = true

}

resource "solacebroker_msg_vpn_kafka_receiver" "default_kafka-receiver" {
  bootstrap_address_list  = "redpanda"
  enabled                 = true
  kafka_receiver_name     = "kafka-receiver"
  msg_vpn_name            = solacebroker_msg_vpn.default.msg_vpn_name

}

resource "solacebroker_msg_vpn_kafka_receiver_topic_binding" "default_kafka-receiver_to-solace" {
  enabled              = true
  kafka_receiver_name  = solacebroker_msg_vpn_kafka_receiver.default_kafka-receiver.kafka_receiver_name
  local_topic          = "bridge/kafka/solace"
  msg_vpn_name         = solacebroker_msg_vpn_kafka_receiver.default_kafka-receiver.msg_vpn_name
  topic_name           = "to.solace"

}

resource "solacebroker_msg_vpn_kafka_sender" "default_kafka-sender" {
  bootstrap_address_list  = "redpanda"
  enabled                 = true
  kafka_sender_name       = "kafka-sender"
  msg_vpn_name            = solacebroker_msg_vpn.default.msg_vpn_name

}

resource "solacebroker_msg_vpn_kafka_sender_queue_binding" "default_kafka-sender_TO-KAFKA" {
  enabled            = true
  kafka_sender_name  = solacebroker_msg_vpn_kafka_sender.default_kafka-sender.kafka_sender_name
  msg_vpn_name       = solacebroker_msg_vpn_kafka_sender.default_kafka-sender.msg_vpn_name
  queue_name         = "TO-KAFKA"
  remote_topic       = "from.solace"

}

resource "solacebroker_msg_vpn_queue" "default_FROM-KAFKA" {
  egress_enabled                                 = true
  event_bind_count_threshold                     = {"clear_percent":60,"set_percent":80}
  event_msg_spool_usage_threshold                = {"clear_percent":18,"set_percent":25}
  event_reject_low_priority_msg_limit_threshold  = {"clear_percent":60,"set_percent":80}
  ingress_enabled                                = true
  msg_vpn_name                                   = solacebroker_msg_vpn.default.msg_vpn_name
  permission                                     = "consume"
  queue_name                                     = "FROM-KAFKA"

}

resource "solacebroker_msg_vpn_queue" "default_FROM-MQ" {
  egress_enabled                                 = true
  event_bind_count_threshold                     = {"clear_percent":60,"set_percent":80}
  event_msg_spool_usage_threshold                = {"clear_percent":18,"set_percent":25}
  event_reject_low_priority_msg_limit_threshold  = {"clear_percent":60,"set_percent":80}
  ingress_enabled                                = true
  msg_vpn_name                                   = solacebroker_msg_vpn.default.msg_vpn_name
  permission                                     = "consume"
  queue_name                                     = "FROM-MQ"

}

resource "solacebroker_msg_vpn_queue" "default_TO-KAFKA" {
  egress_enabled                                 = true
  event_bind_count_threshold                     = {"clear_percent":60,"set_percent":80}
  event_msg_spool_usage_threshold                = {"clear_percent":18,"set_percent":25}
  event_reject_low_priority_msg_limit_threshold  = {"clear_percent":60,"set_percent":80}
  ingress_enabled                                = true
  msg_vpn_name                                   = solacebroker_msg_vpn.default.msg_vpn_name
  permission                                     = "consume"
  queue_name                                     = "TO-KAFKA"

}

resource "solacebroker_msg_vpn_queue" "default_TO-MQ" {
  egress_enabled                                 = true
  event_bind_count_threshold                     = {"clear_percent":60,"set_percent":80}
  event_msg_spool_usage_threshold                = {"clear_percent":18,"set_percent":25}
  event_reject_low_priority_msg_limit_threshold  = {"clear_percent":60,"set_percent":80}
  ingress_enabled                                = true
  msg_vpn_name                                   = solacebroker_msg_vpn.default.msg_vpn_name
  permission                                     = "consume"
  queue_name                                     = "TO-MQ"

}

resource "solacebroker_msg_vpn_queue" "default_q" {
  egress_enabled                                 = true
  event_bind_count_threshold                     = {"clear_percent":60,"set_percent":80}
  event_msg_spool_usage_threshold                = {"clear_percent":18,"set_percent":25}
  event_reject_low_priority_msg_limit_threshold  = {"clear_percent":60,"set_percent":80}
  ingress_enabled                                = true
  msg_vpn_name                                   = solacebroker_msg_vpn.default.msg_vpn_name
  permission                                     = "consume"
  queue_name                                     = "q"

}

resource "solacebroker_msg_vpn_queue_subscription" "default_FROM-KAFKA_bridge-kafka-solace" {
  msg_vpn_name        = solacebroker_msg_vpn_queue.default_FROM-KAFKA.msg_vpn_name
  queue_name          = solacebroker_msg_vpn_queue.default_FROM-KAFKA.queue_name
  subscription_topic  = "bridge/kafka/solace"

}

resource "solacebroker_msg_vpn_queue_subscription" "default_FROM-MQ_connector-mq-solace" {
  msg_vpn_name        = solacebroker_msg_vpn_queue.default_FROM-MQ.msg_vpn_name
  queue_name          = solacebroker_msg_vpn_queue.default_FROM-MQ.queue_name
  subscription_topic  = "connector/mq/solace"

}

resource "solacebroker_msg_vpn_queue_subscription" "default_TO-KAFKA_Insurance--" {
  msg_vpn_name        = solacebroker_msg_vpn_queue.default_TO-KAFKA.msg_vpn_name
  queue_name          = solacebroker_msg_vpn_queue.default_TO-KAFKA.queue_name
  subscription_topic  = "Insurance/\u003e"

}

resource "solacebroker_msg_vpn_queue_subscription" "default_TO-MQ_connector-solace-mq" {
  msg_vpn_name        = solacebroker_msg_vpn_queue.default_TO-MQ.msg_vpn_name
  queue_name          = solacebroker_msg_vpn_queue.default_TO-MQ.queue_name
  subscription_topic  = "connector/solace/mq"

}

resource "solacebroker_msg_vpn_queue_subscription" "default_q_solace-tracing" {
  msg_vpn_name        = solacebroker_msg_vpn_queue.default_q.msg_vpn_name
  queue_name          = solacebroker_msg_vpn_queue.default_q.queue_name
  subscription_topic  = "solace/tracing"

}

resource "solacebroker_msg_vpn_replay_log" "default_Demo" {
  egress_enabled        = true
  ingress_enabled       = true
  max_spool_usage       = 5000
  msg_vpn_name          = solacebroker_msg_vpn.default.msg_vpn_name
  replay_log_name       = "Demo"
  topic_filter_enabled  = true

}

resource "solacebroker_msg_vpn_replay_log_topic_filter_subscription" "default_Demo_Insurance--" {
  msg_vpn_name               = solacebroker_msg_vpn_replay_log.default_Demo.msg_vpn_name
  replay_log_name            = solacebroker_msg_vpn_replay_log.default_Demo.replay_log_name
  topic_filter_subscription  = "Insurance/\u003e"

}

resource "solacebroker_msg_vpn_replay_log_topic_filter_subscription" "default_Demo_solace-tracing" {
  msg_vpn_name               = solacebroker_msg_vpn_replay_log.default_Demo.msg_vpn_name
  replay_log_name            = solacebroker_msg_vpn_replay_log.default_Demo.replay_log_name
  topic_filter_subscription  = "solace/tracing"

}

resource "solacebroker_msg_vpn_telemetry_profile" "default_trace" {
  msg_vpn_name                                                   = solacebroker_msg_vpn.default.msg_vpn_name
  queue_event_bind_count_threshold                               = {"clear_percent":60,"set_percent":80}
  queue_event_msg_spool_usage_threshold                          = {"clear_percent":1,"set_percent":2}
  receiver_acl_connect_default_action                            = "allow"
  receiver_enabled                                               = true
  receiver_event_connection_count_per_client_username_threshold  = {"clear_percent":60,"set_percent":80}
  receiver_max_connection_count_per_client_username              = 1000
  telemetry_profile_name                                         = "trace"
  trace_enabled                                                  = true

}

resource "solacebroker_msg_vpn_telemetry_profile_trace_filter" "default_trace_default" {
  enabled                 = true
  msg_vpn_name            = solacebroker_msg_vpn_telemetry_profile.default_trace.msg_vpn_name
  telemetry_profile_name  = solacebroker_msg_vpn_telemetry_profile.default_trace.telemetry_profile_name
  trace_filter_name       = "default"

}

resource "solacebroker_msg_vpn_telemetry_profile_trace_filter_subscription" "default_trace_default_-_smf" {
  msg_vpn_name            = solacebroker_msg_vpn_telemetry_profile_trace_filter.default_trace_default.msg_vpn_name
  subscription            = "\u003e"
  subscription_syntax     = "smf"
  telemetry_profile_name  = solacebroker_msg_vpn_telemetry_profile_trace_filter.default_trace_default.telemetry_profile_name
  trace_filter_name       = solacebroker_msg_vpn_telemetry_profile_trace_filter.default_trace_default.trace_filter_name

}
