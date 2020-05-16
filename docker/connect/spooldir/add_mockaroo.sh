#!/bin/bash -x

CONNECTOR_NAME=mockaroo
CONFIG_FILE=/connect/spooldir/mockaroo.config

/connect/add_connector.sh ${CONNECTOR_NAME} ${CONFIG_FILE}