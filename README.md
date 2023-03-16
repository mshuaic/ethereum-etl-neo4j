# EthereumETL for Neo4j

ETL for moving Ethereum data to a Neo4j database.

1. Run the import (may take up to 24 hours). If you change the `END_DATE` make sure to also update the disk size 
for the instance:

```bash
export END_BLOCK=14000000
nohup bash batch-import.sh &
tail -f nohup.out
# Monitor the logs
```

2. Create the indexes:

```bash

nohup bash setup-indexes.sh &
sudo systemctl restart neo4j
```

3. Open the Neo4j console at https://<vm_external_ip>:7473/browser/ and run some queries:

```bash
MATCH (address: Address)
RETURN address
LIMIT 10
```

```bash
MATCH (a1:Address { address_string: '0xd8da6bf26964af9d7eed9e03e53415d37aa96045' })-[r]-(a2)
RETURN *
```

Notes:
- values are loaded with type string to Neo4j as there is only Integer and Float types there. Use exact math function
in your queries to convert to BigInteger https://neo4j.com/docs/labs/apoc/current/mathematical/exact-math-functions/.
- Neo4j doesn't allow native indexes for relations. Full-text indexes can be used as a workaround:
https://github.com/neo4j/neo4j/issues/7225
