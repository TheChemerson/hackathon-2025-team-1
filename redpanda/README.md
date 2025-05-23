# Redpanda

An alternative to Apache Kafka.

## Tools

A number of tasks may be accomplished through the [web UI](http://localhost:8084).

Alternatively, Redpanda Keeper (`rpk`) is a single binary application that provides a way to interact with Redpanda clusters from the command line.  `rpk` can either be run from the Docker container or [installed separately](https://docs.redpanda.com/current/get-started/rpk-install/).

## Creating a Topic

The create a topic named `from_solace` with a retention of 1 hour.

- Use Redpanda web UI [http://localhost:8084](http://localhost:8084)

- Use RPK:

```console
rpk topic create from_solace -c retention.ms=3600000
```

Use RPK through Docker:

```console
docker exec -it redpanda rpk topic create from_solace -c retention.ms=3600000
```

## Reading a Topic

- Use Redpanda web UI [http://localhost:8084](http://localhost:8084)

- Use RPK:

```console
rpk topic consume from_solace
```

- Use RPK through Docker:

```console
docker exec -it redpanda rpk topic consume from_solace
```
