#!/usr/bin/with-contenv bashio

# Enable strict mode for bash (exit on error, error on undefined variable, error if any pipeline element fails)
set -euo pipefail
# Fetch values from the add-on configuration by extracting it from /data/options.json

HA_MQTT_BROKER_HOST=$(bashio::services mqtt "host")
HA_MQTT_USERNAME=$(bashio::services mqtt "username")
HA_MQTT_PASSWORD=$(bashio::services mqtt "password")

INVERTER_HOST=$(bashio::config 'inverter_host')
MQTT_BROKER_HOST=$(bashio::config 'mqtt_broker_host')
MQTT_USERNAME=$(bashio::config 'mqtt_username')
MQTT_PASSWORD=$(bashio::config 'mqtt_password')
MQTT_PORT=$(bashio::config 'mqtt_port')

# Use bashio::config values if they are defined, otherwise fall back to bashio::services values
MQTT_BROKER_HOST=${MQTT_BROKER_HOST:-$HA_MQTT_BROKER_HOST}
MQTT_USERNAME=${MQTT_USERNAME:-$HA_MQTT_USERNAME}
MQTT_PASSWORD=${MQTT_PASSWORD:-$HA_MQTT_PASSWORD}


# Check if the required configs are provided
if [[ -z "$INVERTER_HOST" ]]; then
  echo "The inverter_host is not configured."
  exit 1
fi

if [[ -z "$MQTT_BROKER_HOST" ]]; then
  echo "The mqtt_broker_host is not configured."
  exit 1
fi

if [[ -z "$MQTT_USERNAME" ]]; then
  echo "The mqtt_username is not configured."
  exit 1
fi

if [[ -z "$MQTT_PASSWORD" ]]; then
  echo "The mqtt_password is not configured."
  exit 1
fi

# Execute the application with the configuration
/usr/local/bin/hms-mqtt-publish "$INVERTER_HOST" "$MQTT_BROKER_HOST" "$MQTT_USERNAME" "$MQTT_PASSWORD" "$MQTT_PORT"