SELECT
    formatDateTime(timestamp, '%Y-%m-%dT%T%z') AS timestamp,
    number,
    `hash`,
    parent_hash,
    nonce,
    sha3_uncles,
    logs_bloom,
    transactions_root,
    state_root,
    receipts_root,
    miner,
    difficulty,
    total_difficulty,
    size,
    extra_data,
    gas_limit,
    gas_used,
    transaction_count
FROM blocks_raw 
WHERE number >= {start_block:UInt64}  AND number <= {end_block:UInt64}
LIMIT 1 by number
