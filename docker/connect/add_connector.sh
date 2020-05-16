#!/bin/bash -x

CONNECT_SERVER=http://connect:8083/connectors
CONNECTOR_NAME=$1
CONFIG_FILE=$2

if [ "${CONNECTOR_NAME}" = "" ]; then
    echo "No connector name specified"
    exit 1
fi

if [ "${CONFIG_FILE}" = "" ]; then
    echo "No config file specified"
    exit 1
fi

if [ ! -f ${CONFIG_FILE} ]; then
    echo "No config file with the path (${CONFIG_FILE}) found."
    exit 1
fi

# Check if there is already a config for the connector
EXISTS=$(curl -X GET -s -o/dev/null -w '%{http_code}' ${CONNECT_SERVER}/${CONNECTOR_NAME})

# If there is a valid connector then delete it
if [[ ${EXISTS} == 200 ]]; then
  curl -X DELETE \
    ${CONNECT_SERVER}/${CONNECTOR_NAME}
fi

# This is for the datagen to generate insane numbers of data for testing
curl -H "Content-Type: application/json" \
  -X POST \
  --data @${CONFIG_FILE} \
  ${CONNECT_SERVER}