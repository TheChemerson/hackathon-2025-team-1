# bin/bash

enable_print_only=false

while getopts "p" opt; do
    case $opt in
        p)
            enable_print_only=true
            ;;
    esac
done

### module options
enable_event_mesh=true
enable_distributed_tracing=true
enable_kafka_bridges=true
enable_replay=false

### integration options
enable_file_mesh=false
enable_connector_file=true
enable_connector_file_delta=false
enable_connector_file_to_event=true
enable_connector_ibmmq=true
enable_connector_mongodb=false
enable_connector_tibco=true
enable_connector_sftp=false
enable_connector_s3=false

### business domain
enable_domain_insurance=true
enable_domain_retail=false

### authentication options
enable_ldap=false


### Global Variables!

admin="admin:admin"
server="https://localhost:1943"
vpn="default"
cluster_password="demo-local-cluster-Admin"
default_profile="default"


semp=$server"/SEMP/v2"
semp_config=$semp"/config"
semp_vpn=$semp_config"/msgVpns/"$vpn

semp_v1=$server"/SEMP"
if $enable_ldap ; then
  printf "Please enter solace broker version for use in SEMP v1 Commands\n"
  read semp_v1_version
fi

replayLogName=Demo


### Functions

print_http_status() {

    WARN='\033[1;31m'
    GOOD='\033[0;32m'
    NORM='\033[0m'

    if [[ "$1" -ne 200 ]] ; then
        echo "${WARN}$1${NORM}"
    else
        echo "${GOOD}$1${NORM}"
    fi
}

semp2() {
    local verb=${1}
    local endpoint=${2}
    local payload=${3}
    
    if $enable_print_only ; then
        echo
        echo
        echo curl -ks -u $admin -X $verb $endpoint -H '"Content-Type: application/json"' -H '"Accept: application/json"' -d "'"$payload"'"
        echo
    else
        status=$(curl -ks -w "%{http_code}" -o /dev/null -u $admin -X $verb $endpoint -H "Content-Type: application/json" -H "Accept: application/json" -d "$payload")
        print_http_status $status
    fi
}

patch_semp2() {
    local endpoint=${1}
    local payload=${2}

    semp2 "PATCH" ${endpoint} "$payload"
}

post_config2() {
    local endpoint=${1}
    local payload=${2}

    semp2 "POST" ${semp_config}${endpoint} "$payload"
}

post_semp_v1() {
  printf "... "
  local payload=${1}

  semp "POST" ${semp_v1} "$payload"
}

post_semp2() {
    local endpoint=${1}
    local payload=${2}

    semp2 "POST" ${semp_vpn}${endpoint} "$payload"
}

create_queue() {
    printf "Creating queue ${1}...  "
    post_semp2 "/queues" \
               '{
                     "queueName": "'${1}'",
                     "egressEnabled": true,
                     "ingressEnabled": true,
                     "maxMsgSpoolUsage": '${2:-5000}',
                     "permission": "consume"
                }'
}

create_queue_subscription() {
    printf "Adding subscription ${2} to ${1}...  "
    post_semp2 "/queues/${1}/subscriptions" \
               '{
                     "subscriptionTopic": "'$2'"
                }'
}

create_replay_subscription() {
    if [ "$enable_replay" = true ] ; then  # only add replay subscription if replay is enabled
        printf "Adding replay topic filter $1 to $replayLogName...  "
        post_semp2 "/replayLogs/$replayLogName/topicFilterSubscriptions" '{ "topicFilterSubscription": "'${1}'" }'
    fi
}

create_acl_profile() {
    printf "Creating ACL profile ${1}...  "
    post_semp2 "/aclProfiles" \
               '{ 
                    "aclProfileName": "'$1'",
                    "clientConnectDefaultAction": "'$2'",
                    "publishTopicDefaultAction": "'$3'",
                    "subscribeShareNameDefaultAction": "'$4'",
                    "subscribeTopicDefaultAction": "'$5'"
                }'
}

create_client_profile() {
    printf "Creating client profile ${1}...  "
    post_semp2 "/clientProfiles" \
               '{ 
                     "clientProfileName": "'$1'",
                     "allowGuaranteedEndpointCreateDurability": "all",
                     "allowGuaranteedMsgReceiveEnabled": true,
                     "allowGuaranteedMsgSendEnabled": true,
                     "rejectMsgToSenderOnNoSubscriptionMatchEnabled": '$2'
                }'
}

create_client_username() {
    printf "Creating client username ${1}...  "
    post_semp2 "/clientUsernames" \
               '{ 
                     "clientUsername": "'$1'",
                     "password": "'$2'",
                     "aclProfileName": "'$3'",
                     "clientProfileName": "'$4'",
                     "enabled": true
                }'
}


### Actual calls

if !($enable_print_only) ; then
    echo
    printf "Waiting for PubSub+ to come online"
    until [ "$(curl -ks -w '%{http_code}' -o /dev/null -u $admin $semp/monitor/)" -eq 200 ]
    do
        printf "."
        sleep 1  # retry in 1 second
    done
    printf "\n\n"
fi


##### Initialize

printf "Set System Max Spool Usage...  "
patch_semp2 $semp_config '{ "guaranteedMsgingMaxMsgSpoolUsage": 15000 }'

printf "Set Max Message Spool and Authentication Type...  "
patch_semp2 $semp_vpn '{ "authenticationBasicType": "internal", "maxMsgSpoolUsage": 15000 }'
echo

printf "Set Default User Password...  "
patch_semp2 "$semp_vpn/clientUsernames/$default_profile" '{ "password": "default" }'

printf "Set default user client profile...  "
patch_semp2 "$semp_vpn/clientProfiles/$default_profile" \
           '{ 
                "allowGuaranteedMsgReceiveEnabled": true,
                "allowGuaranteedMsgSendEnabled": true
            }'
echo

##### Configure LDAP
if $enable_ldap ; then
    source semp-module/enable-ldap.sh
fi

##### End LDAP Configuration


##### Event Mesh

if $enable_event_mesh ; then

    cluster_name="Local-$RANDOM"

    # No need to enable DMR as it is enabled by default

    printf "Creating local cluster...  "
    post_config2 "/dmrClusters" \
            '{ 
                    "authenticationBasicPassword": "'$cluster_password'", 
                    "authenticationClientCertEnabled": false, 
                    "dmrClusterName": "Local-'$cluster_name'", 
                    "enabled": true
            }'
    echo

    # printf "Creating link..."

    # printf "Adding connection information for remote node..."

    # printf "Creating a cluster linking queue..."

    # printf "Creating a DMR bridge..."

    ##########
    # mr-connection-9ee88bp06j4.messaging.solace.cloud:55443 
    # mr-connection-9ee88bp06j4.messaging.solace.cloud:943 
    ##########

fi


##### Replay
# Keep this section early in the script in case there are multiple replay subscriptions.
if $enable_replay ; then
    source semp-module/enable-replay.sh
fi

##### Distributed Tracing
if $enable_distributed_tracing ; then
    source semp-module/enable-distributed-tracing.sh
fi

##### Kafka Bridge
if $enable_kafka_bridges ; then
    source semp-module/enable-kafka-bridges.sh
fi


##### Connectors

# Create user for connectors
if [ "$enable_file_mesh" = true ] \
|| [ "$enable_connector_file" = true ] \
|| [ "$enable_connector_file_delta" = true ] \
|| [ "$enable_connector_file_to_event" = true ] \
|| [ "$enable_connector_sftp" = true ] \
|| [ "$enable_connector_ibmmq" = true ] \
|| [ "$enable_connector_tibco" = true ] \
|| [ "$enable_connector_mongodb" = true ] ; then

    create_acl_profile "acl-connector" "allow" "allow" "allow" "allow"
    create_client_profile "client-connector" false
    
    create_acl_profile "read-only" "allow" "disallow" "disallow" "disallow"
    
    if ! $enable_ldap ; then
        create_client_username "connector" "connector" "acl-connector" "client-connector"
        create_client_username "healthcheck" "healthcheck" "read-only" "default"
    else
        printf "LDAP is enabled, not creating client usernames on the broker"
    fi
    
    echo

fi


##### File Mesh
if $enable_file_mesh ; then
    source semp-module/file-mesh.sh
fi  # File Mesh


##### Connector - File
if $enable_connector_file ; then
    source semp-module/connector-file.sh
fi  # Connector - File


##### Connector - File Delta
if $enable_connector_file_delta ; then
    source semp-module/connector-file-delta.sh
fi  # Connector - File Delta


##### Connector - File to Event
if $enable_connector_file_to_event ; then
    source semp-module/connector-file-to-event.sh
fi  # end of Connector - File-to-Events


##### Connector - File to FTP
if $enable_connector_sftp ; then

    queue="CONN-SFTP"
    create_queue $queue
    create_queue_subscription $queue "solace/fc/source/base"
    create_queue_subscription $queue "solace/fc/source/base/file/*"

    create_queue "CONN-MGMT-SFTP"

fi  # end of Connector - SFTP


##### Connector - IBM MQ
if $enable_connector_ibmmq; then
    source semp-module/connector-ibmmq.sh
fi  # end of Connector - IBM MQ


##### Connector - MongoDb
if $enable_connector_mongodb; then
    source semp-module/connector-cdc-mongo.sh
fi  # end of Connector - MongoDb


##### Connector - TIBCO EMS
if $enable_connector_tibco; then
    source semp-module/connector-tibco.sh
fi  # end of Connector - TIBCO EMS


##### Solace-to-AWS-S3
if $enable_connector_s3 ; then
    source semp-module/connector-aws-s3.sh
fi  # end of Solace-to-AWS-S3


#### Business Domain

if $enable_domain_retail; then
    source semp-module/domain-retail.sh
fi