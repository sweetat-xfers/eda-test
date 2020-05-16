#!/bin/bash -x

CONNECTOR_NAME=datagen-stocktrades
CONFIG_FILE=/connect/datagen/stock_trades.config

/connect/add_connector.sh ${CONNECTOR_NAME} ${CONFIG_FILE}