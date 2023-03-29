SELECT
    `hash`,
    nonce,
    transaction_index,
    from_address,
    COALESCE(to_address, receipt_contract_address) AS to_address,
    value,
    gas,
    gas_price,
    receipt_cumulative_gas_used,
    receipt_gas_used,
    receipt_contract_address,
    receipt_root,
    receipt_status,
    formatDateTime(block_timestamp, '%Y-%m-%dT%T%z') AS block_timestamp,
    block_number
FROM transactions_raw
WHERE block_number >= {start_block:UInt64}  AND block_number <= {end_block:UInt64}
