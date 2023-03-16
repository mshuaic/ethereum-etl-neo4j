SELECT
    trace_id,
    transaction_hash,
    transaction_index,
    COALESCE(from_address, '0x0000000000000000000000000000000000000000') AS from_address,
    COALESCE(to_address, '0x0000000000000000000000000000000000000000') AS to_address,
    value,
    trace_type,
    call_type,
    reward_type,
    gas,
    gas_used,
    subtraces,
    trace_address,
    error,
    status,
    formatDateTime(block_timestamp, '%Y-%m-%dT%T%z') AS block_timestamp,
    block_number
FROM traces_raw
WHERE block_number >= {start_block:UInt64}  AND block_number <= {end_block:UInt64}
LIMIT 1 BY (block_number, trace_id)
