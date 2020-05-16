#!/bin/bash -x


CONNECTOR_NAME=datagen-bankrows
CONFIG_FILE=/connect/datagen/bank_rows.config

/connect/add_connector.sh ${CONNECTOR_NAME} ${CONFIG_FILE}