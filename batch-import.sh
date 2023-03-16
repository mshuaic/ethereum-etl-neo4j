#!/usr/bin/env bash
set -e


# clickhouse client binary path
CHC=/usr/bin/clickhouse-client
NEO4j_ROOT=/home/mark/neo4j-community-5.5.0/
NEO4j_ADMIN=$NEO4j_ROOT/bin/neo4j-admin
HEADERS=/home/mark/ethereum-etl-neo4j/headers
IMPORT_FOLDER=/home/mark/ethereum-etl-neo4j/import
TEMP_BQ_DATASET=ethereum_etl_neo4j_temp
TEMP_DATA_FOLDER=ethereum_etl_neo4j_temp

QUERY_START_BLOCK=${START_BLOCK:-0}
QUERY_END_DATE=${END_DATE:-14000000}


function export_tables {
    for file in $(ls query/*.sql); do
        TABLE="$(basename $file .sql)"
        QUERY="$(cat $file | tr "\n" " ")"
        FOLDER="${IMPORT_FOLDER}/$TABLE"
        mkdir -p ${FOLDER} || true
        echo "Exporting table $TABLE to $FOLDER"
        echo "$QUERY"
        $CHC --database "ethereum" \
             --query "$QUERY" \
             --format CSV \
             --param_start_block=${QUERY_START_BLOCK} \
             --param_end_block=${QUERY_END_DATE} \
             > "$FOLDER/$TABLE.csv"
    done
}


function run_import {
    command rm -rf $NEO4j_ROOT/data/databases/ethereum.db
    command rm -rf $NEO4j_ROOT/data/transactions/ethereum.db
    $NEO4j_ADMIN database import full \
        ethereum.db \
        --verbose \
        --report-file /tmp/import-report.txt \
        --nodes=Address="${HEADERS}/addresses.csv,${IMPORT_FOLDER}/addresses/addresses.csv" \
        --nodes=Block="${HEADERS}/blocks.csv,${IMPORT_FOLDER}/blocks/blocks.csv" \
        --relationships=TRANSACTION="${HEADERS}/transactions.csv,${IMPORT_FOLDER}/transactions/transactions.csv" \
        --relationships=TRACE="${HEADERS}/traces.csv,${IMPORT_FOLDER}/traces/traces.csv" \
        --relationships=TOKEN_TRANSFER="${HEADERS}/token_transfers.csv,${IMPORT_FOLDER}/token_transfers/token_transfers.csv"
}

export_tables
run_import

