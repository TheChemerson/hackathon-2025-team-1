# File to Event Connector

## Prerequisites

Before the Connector can be used, one must first obtain and "install" the Docker image.

### Docker Image

It is necessary to obtain Docker image from [Hub](https://solacesystems.sharepoint.com/:u:/r/sites/TechGarage/Shared%20Documents/Tech%20COE/Connectors/File%20%26%20SFTP/2.1.1/pubsubplus-connector-file-2.1.1/docker-image/pubsubplus-connector-file-2.1.1-image.tar?csf=1&web=1&e=oIbLaj).  The current image to use is `pubsubplus-connector-file-2.1.1-image.tar`.  Once the image file is available, run the following command to make it available to Docker:

```shell
docker load -i pubsubplus-connector-file-2.1.1-image.tar
```

### Scenarios

| File Type | Flow | Description |
| :-------: | :--: | ----------- |
| 1         | 0    | retransmit file a events; connector exits |
| 2         | 1    | transmit new events only; connector exits on file change |
| 3         | 2    | transmit new files only; connector does not monitor folder change |
