### Init

queue="TO-MSSQL"

create_queue $queue
create_queue_subscription $queue "acmebank/solace/core/deposit/v1/*/*/>"
create_queue_subscription $queue "acmebank/solace/core/withdrawal/v1/*/*/>"
