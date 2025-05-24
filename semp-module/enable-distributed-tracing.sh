otel_profile="trace"
queue="q"

sleep 2
printf "Create telemetry profile...  "
post_semp2  "/telemetryProfiles" \
            '{
                "msgVpnName": "'$vpn'",
                "receiverAclConnectDefaultAction": "allow",
                "receiverEnabled": true,
                "telemetryProfileName": "'$otel_profile'",
                "traceEnabled": true
            }'

printf "Create trace filter...  "
post_semp2  "/telemetryProfiles/$otel_profile/traceFilters" \
            '{ 
                "enabled": true,
                "traceFilterName": "default"
            }'

printf "Create trace filter subscription...  "
post_semp2  "/telemetryProfiles/$otel_profile/traceFilters/default/subscriptions" \
            '{ 
                "subscription": ">",
                "subscriptionSyntax": "smf"
            }'
echo

create_client_username "trace" "trace" "#telemetry-trace" "#telemetry-trace"

# Create Queue

create_queue $queue
create_queue_subscription $queue "solace/tracing"
create_replay_subscription "solace/tracing"
echo