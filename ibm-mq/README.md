IBM MQ does not have a container image for use with Apple Silicon (Arm64) machines. Follow the instructions below to build a container image for use on Apple m-machines

Taken from [New IBM MQ 9.3.3.0 Container image for Apple Silicon (Arm64)](https://community.ibm.com/community/user/integration/blogs/richard-coppen/2023/06/30/ibm-mq-9330-container-image-now-available-for-appl)
1. Create Container Image
   1. `git clone https://github.com/ibm-messaging/mq-container.git`
   2. `cd mq-container`
   3. `make build-devserver`
      
   Limitations: It is not possible to run the IBM MQ XR component which provides MQTT and AMQP based messaging.
   
2. Once the image has been succesfully:
   1. Query Docker for the current image tag through `docker images | grep ibm-mq` 
   2. Update image name in  `./docker-compose.yaml` to `image: ibm-mqadvanced-server-dev:<tag>` where `<tag>` is the value retrieved from the previous step.

That's it!