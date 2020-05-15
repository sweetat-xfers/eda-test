#!/bin/bash

if [ ! -f docker/connect/connect_datagen_stock_trades.config ]; then
  echo "Wrong directory.  Pls run in the main project directory"
fi

## This is for the datagen to generate insane numbers of data for testing
curl -X POST \
  -H "Content-Type: application/json" \
  --data @docker/connect/connect_datagen_stock_trades.config \
  http://localhost:8083/connectors