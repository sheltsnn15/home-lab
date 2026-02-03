<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [SONOFF SNZB-04P (Door/Window Sensor) Documentation](#sonoff-snzb-04p-doorwindow-sensor-documentation)
  - [Device Information](#device-information)
  - [MQTT Topics](#mqtt-topics)
    - [Main State Topic](#main-state-topic)
    - [Availability Topic](#availability-topic)
  - [Discovered Entities](#discovered-entities)
    - [1. Door Contact Sensor](#1-door-contact-sensor)
    - [2. Battery Low Indicator](#2-battery-low-indicator)
    - [3. Tamper Detection](#3-tamper-detection)
    - [4. Battery Level Sensor](#4-battery-level-sensor)
    - [5. Firmware Update](#5-firmware-update)
  - [Device Status Information](#device-status-information)
  - [Typical Values](#typical-values)
  - [Troubleshooting](#troubleshooting)
  - [Zigbee2MQTT Integration](#zigbee2mqtt-integration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---

# SONOFF SNZB-04P (Door/Window Sensor) Documentation

## Device Information

- **Manufacturer**: SONOFF
- **Model**: SNZB-04P (Contact sensor)
- **Device ID**: `0x08ddebfffe0ff8d5`
- **Via Device**: `zigbee2mqtt_bridge_0x187a3efffe396264`

## MQTT Topics

### Main State Topic

- **Topic**: `zigbee2mqtt/dinning_balcony_ds`
- **Payload Example**:

  ```json
  {
    "battery": 100,
    "battery_low": false,
    "contact": true,
    "linkquality": 180,
    "tamper": false,
    "update": {
      "installed_version": 8704,
      "latest_version": 8704,
      "state": "idle"
    },
    "voltage": 3100
  }
  ```

### Availability Topic

- **Topic**: `zigbee2mqtt/bridge/state`
- **Payload**: `{"state": "online"}` (or "offline")

## Discovered Entities

### 1. Door Contact Sensor

- **Entity ID**: `binary_sensor.dinning_balcony_ds_contact`
- **Device Class**: `door`
- **State Topic**: `zigbee2mqtt/dinning_balcony_ds`
- **Value Template**: `{{ value_json.contact }}`
- **Payloads**:
  - Open: `false`
  - Closed: `true`

### 2. Battery Low Indicator

- **Entity ID**: `binary_sensor.dinning_balcony_ds_battery_low`
- **Device Class**: `battery`
- **Entity Category**: `diagnostic`
- **State Topic**: `zigbee2mqtt/dinning_balcony_ds`
- **Value Template**: `{{ value_json.battery_low }}`
- **Payloads**:
  - Normal: `false`
  - Low battery: `true`

### 3. Tamper Detection

- **Entity ID**: `binary_sensor.dinning_balcony_ds_tamper`
- **Device Class**: `tamper`
- **State Topic**: `zigbee2mqtt/dinning_balcony_ds`
- **Value Template**: `{{ value_json.tamper }}`
- **Payloads**:
  - Normal: `false`
  - Tamper detected: `true`

### 4. Battery Level Sensor

- **Entity ID**: `sensor.dinning_balcony_ds_battery`
- **Device Class**: `battery`
- **Entity Category**: `diagnostic`
- **State Topic**: `zigbee2mqtt/dinning_balcony_ds`
- **Value Template**: `{{ value_json.battery }}`
- **Unit of Measurement**: `%`

### 5. Firmware Update

- **Entity ID**: `update.dinning_balcony_ds`
- **Device Class**: `firmware`
- **Entity Category**: `config`
- **State Topic**: `zigbee2mqtt/dinning_balcony_ds`
- **Command Topic**: `zigbee2mqtt/bridge/request/device/ota_update/update`
- **Payload Install**: `{"id": "0x08ddebfffe0ff8d5"}`

## Device Status Information

The device regularly reports:

- Battery level (percentage and voltage)
- Contact status (open/closed)
- Tamper status
- Link quality indicator
- Firmware update status

## Typical Values

- **Battery**: 100% (voltage ~3.1V when full)
- **Link Quality**: 170-180 (higher is better)
- **Firmware Version**: 8704

## Troubleshooting

1. **Device not responding**:
   - Check `zigbee2mqtt/bridge/state` for bridge status
   - Verify battery level
   - Check link quality (values below 50 may indicate connection issues)

2. **False tamper alerts**:
   - Ensure the device is properly mounted
   - Check for physical disturbances

3. **Update issues**:
   - Verify the device is awake during update attempts
   - Ensure stable network connection
