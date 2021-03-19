#!/usr/bin/env bash

set -e

echo "Pre-processing CSV file."
python scripts/pre_processing.py

echo "Inserting CSV into events.raw.events_log"
dbt seed --target raw --profiles-dir /home/werkspot/

echo "Running models"
dbt run --profiles-dir /home/werkspot/
