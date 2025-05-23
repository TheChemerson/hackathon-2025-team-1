# Enable TLS with Self-signed Certificate

A self-signed certificate enables TLS services in the broker.  This is necesary if one is interested in creating a mesh with local and Solace Cloud brokers.  Please note, this exercise should be done once a year; otherwise, the certificate expiration should be a day far into the future.

## Creating Self-signed Certificate

To generate a self-signed certificate, follow these steps:

1. Edit openssl.cnf to define the desired certificate properties, such as the subject details (*e.g.*, country, state, organization).
2. If you want to specify your own passphrase, update the passphrase file with your chosen passphrase.

Once these files are prepared, run the following command to create the certificate and private key:

```shell
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out server.pem -days 365 -config openssl.cnf -passout file:passphrase
```

The resulting certificate and the encrypted private key will need to be combined into a single file:

```shell
cat key.pem >> server.pem
```

Notes:

- File Security: Ensure that both openssl.cnf and passphrase are secured with appropriate permissions (`chmod 600`).
- Combined File Usage: The combined `server.pem` file can be used in environments that require the certificate and private key in a single file.

## Add Certificate to PubSub+ Manually (Optional)

`<container>` referenced below is the name of the PubSub+ container.  The default value is `solace`.

1. Copy the self-signed certificate to `jail`.

    ```shell
    docker cp server.pem <container>:/usr/sw/jail/certs
    ```

1. Start the CLI (once the broker has finished the start up procedure)

    ```shell
    docker exec -it <container> /usr/sw/loads/currentload/bin/cli -A
    ```

1. Install the certificate via the CLI

    ```shell
    solace> enable 
    solace# configure 
    solace(configure)# ssl 
    solace(configure/ssl)# server-certificate server.pem 
    solace(configure/ssl)# home
    ```
