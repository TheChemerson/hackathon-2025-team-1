# hackathon-2025-team-1

## Overview

Welcome to the **Fictitious Bank Event Mesh Demo**, showcasing how a modern bank can liberate and route real-time business events — such as customer updates, payments, and insurance claims — across a hybrid event mesh powered by **Solace PubSub+**. This bank provides both **Retail Banking** and **Insurance** services.

This demo illustrates:

- Event streaming from databases and applications into Solace.
- Event routing across an enterprise event mesh.
- Event delivery to various back-end systems such as **Kafka**, **TIBCO EMS**, **IBM MQ**, **Microsoft SQL Server**, and **AWS S3**.
- Smart topic-based routing using Solace’s **dynamic hierarchical topics**.

## Architecture

![architecture diagram](<graphics/Hackathon 2025.png>)

## Components

### Event Sources

- **CDC App**: Monitors a relational database for changes to **customer records** and publishes events to Solace.
- **C# Application**: Publishes **insurance claim events** using Solace smart topics.
- **JavaScript Application**: Publishes mocked **payment events** using [feeds.solace.dev](https://feeds.solace.dev).

### Event Routing

- All applications publish events to Solace using **smart topics** to allow intelligent filtering and delivery.
- Example topic structure:  
For example:
- `acmebank/solace/core/payment/...`
- `acmebank/insurance/claim/...`
- `acmebank/customer/...`

### Subscribers

Each event type is routed to one or more of the following systems based on topic filters:

| Event Type         | Destination(s)                        |
|--------------------|---------------------------------------|
| Customer Info      | Kafka                                 |
| Payments           | TIBCO EMS and SQL Server (for record) |
| Insurance Claims   | IBM MQ                                |
| All Events         | AWS S3 (archival)                     |

### Smart Topics

Topic filters are used by subscriber micro-integrations to route only relevant messages to each destination. For instance:

- Kafka subscriber filters: `acmebank/customer/*/*`
- EMS subscriber filters: `acmebank/*/*/payment/>`
- SQL Server: `acmebank/solace/core/deposit/v1/*/*/>` and `acmebank/solace/core/deposit/v1/*/*/>`
- S3: subscribes to all topics: `acmebank/>`

## Running the Demo

1. **Start containers** run the following command from the root folder of the project `docker compose up -d ; ./semp.sh`
2. **Create database objects** run the following command from inside the MSSQL container.
3. **Run C# application** to send claim events.
4. **Launch JavaScript event simulator** from `feeds.solace.dev`
5. **Restart micro-integrations as necessary**
6. **Observe events routed by topic filtering and delivered to their destinations**

## Topic Example

| Topic                               | Description                        |
|-------------------------------------|------------------------------------|
| `bank/retail/customer/update`       | Customer updates from CDC          |
| `bank/retail/payment/transaction`   | Payment events from JS app         |
| `bank/insurance/claim/new`          | New insurance claims from C# app   |

## Conclusion

This demo shows how **event-driven architecture** enables seamless communication between systems with diverse integration needs, all through the **power of smart topic routing** and an **event mesh** built with Solace.