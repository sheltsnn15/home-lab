#!/bin/bash
set -e

# Source the .env file
source ../.env

# Replace placeholders in configuration.yaml
sed -i "s|\${MQTT_USERNAME}|${MQTT_USERNAME}|g" /app/data/configuration.yaml
sed -i "s|\${MQTT_PASSWORD}|${MQTT_PASSWORD}|g" /app/data/configuration.yaml
