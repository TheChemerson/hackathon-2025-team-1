# TIBCO EMS

## Prerequisites

It is necessary to build the Docker image first.

```console
docker image build . -t demo/tibco:10.2.1
```

## tibemsadmin

TIBCO EMS configuration, managemment, and monitoring may be done via TIBEMSAdmin.  It is located in the `bin` folder in the container.  To launch it:

```console
cd /opt/tibco/ems/10.2/bin
./tibemsadmin
```

At the prompt:

```console
TIBCO Enterprise Message Service Administration Tool.
Copyright 1997-2022 by TIBCO Software Inc.
All rights reserved.

Version 10.2.1 V1 2022-11-03

Type 'help' for commands help, 'exit' to exit:
>
```

Enter `c` then hit `return` 3 times.  This will connect you to the local instance as `admin`.

If all went well, you should see the next prompt:

```console
Connected to: tcp://localhost:7222
tcp://localhost:7222> 
```

## Useful Commands

| Command             | Description                              |
| ------------------- | ---------------------------------------- |
| `h` or `help`       | To display a list of possible commands.  |
| `show queues`       | To display queues and their basic stats. |
| `show queue <name>` | To display details of the named queue.   |
| `q` or `quit`       | To exit the admin console.               |
