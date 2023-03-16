SELECT
    token_address,
    COALESCE(from_address, '0x0000000000000000000000000000000000000000') AS from_address,
    COALESCE(to_address, '0x0000000000000000000000000000000000000000') AS to_address,
    value,
    transaction_hash,
    log_index,
    formatDateTime(block_timestamp, '%Y-%m-%dT%T%z') AS block_timestamp,
    block_number
FROM token_transfers_raw
WHERE block_number >= {start_block:UInt64}  AND block_number <= {end_block:UInt64}
LIMIT 1 BY (block_number, transaction_hash, log_index)
