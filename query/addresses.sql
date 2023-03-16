SELECT DISTINCT from_address as address
FROM transactions_raw
WHERE block_number >= {start_block:UInt64}  AND block_number <= {end_block:UInt64}

UNION DISTINCT

SELECT DISTINCT COALESCE(to_address, receipt_contract_address)
FROM transactions_raw
WHERE block_number >= {start_block:UInt64}  AND block_number <= {end_block:UInt64}

UNION DISTINCT

SELECT DISTINCT COALESCE(from_address, '0x0000000000000000000000000000000000000000')
FROM traces_raw
WHERE block_number >= {start_block:UInt64}  AND block_number <= {end_block:UInt64}

UNION DISTINCT

SELECT DISTINCT COALESCE(to_address, '0x0000000000000000000000000000000000000000')
FROM traces_raw
WHERE block_number >= {start_block:UInt64}  AND block_number <= {end_block:UInt64}

UNION DISTINCT

SELECT DISTINCT COALESCE(from_address, '0x0000000000000000000000000000000000000000')
FROM token_transfers_raw
WHERE block_number >= {start_block:UInt64}  AND block_number <= {end_block:UInt64}

UNION DISTINCT

SELECT DISTINCT COALESCE(to_address, '0x0000000000000000000000000000000000000000')
FROM token_transfers_raw
WHERE block_number >= {start_block:UInt64}  AND block_number <= {end_block:UInt64}
