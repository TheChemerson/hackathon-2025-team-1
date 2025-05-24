printf "Enabling Replay...  "
post_semp2  "/replayLogs" \
            '{
                "egressEnabled": true,
                "ingressEnabled": true,
                "maxSpoolUsage": 5000,
                "replayLogName": "'$replayLogName'",
                "topicFilterEnabled": true
            }'

sleep 5
create_replay_subscription "Insurance/>"
echo
