#!/bin/bash

## This is for the datagen to generate insane numbers of data for testing
curl -X POST \
  -H "Content-Type: application/json" \
  --data @connector_stock_trades.config \
  http://localhost:8083/connectors