# Read Me

## Setup

```console
export BROKER_PASSWORD=admin
export EMA_BROKER=9nlkuqpb5uu
export EMA_NAME=event-management-agent
export EMA_FOLDER=${HOME}/Documents/GitHub/quick-demo/${EMA_NAME}
export EMA_OUTPUT=scan.zip
export EMA_CMD_BASE="/tmp/${EMA_OUTPUT} --springdoc.api-docs.enabled=false --spring.main.web-application-type=none"
```

## Scan

```console
docker run -d --rm --network=demo-net -v ${EMA_FOLDER}/config/standalone.yml:/config/ema.yml -v ${EMA_FOLDER}/output:/tmp --env CMD_LINE_ARGS="scan ${EMA_BROKER} ${EMA_CMD_BASE}" --env BROKER_PASSWORD=${BROKER_PASSWORD} --name ${EMA_NAME} solace/${EMA_NAME}:latest
```

## Upload

```console
docker run -d --rm -v ${EMA_FOLDER}/config/connected.yml:/config/ema.yml -v ${EMA_FOLDER}/output/${EMA_OUTPUT}:/tmp/${EMA_OUTPUT} --env CMD_LINE_ARGS="upload ${EMA_CMD_BASE}" --env BROKER_PASSWORD=${BROKER_PASSWORD} --name ${EMA_NAME} solace/${EMA_NAME}:latest
```
