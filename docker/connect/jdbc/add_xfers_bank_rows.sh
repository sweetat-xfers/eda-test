#!/bin/bash -x


CONNECTOR_NAME=jdbc-xfers-bankrows
CONFIG_FILE=/connect/jdbc/xfers_bank_rows.config

/connect/add_connector.sh ${CONNECTOR_NAME} ${CONFIG_FILE}