<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Tuya ZA03 (Zigbee Siren Alarm) Documentation](#tuya-za03-zigbee-siren-alarm-documentation)
  - [Device Information](#device-information)
  - [MQTT Topics](#mqtt-topics)
    - [Main State Topic](#main-state-topic)
    - [Availability Topic](#availability-topic)
  - [Discovered Entities](#discovered-entities)
    - [1. Alarm Switch](#1-alarm-switch)
    - [2. Volume Control](#2-volume-control)
    - [3. Ringtone Selection](#3-ringtone-selection)
    - [4. Duration Control](#4-duration-control)
  - [Device Status Information](#device-status-information)
  - [Configuration Options](#configuration-options)
    - [Setting Alarm Duration](#setting-alarm-duration)
    - [Changing Ringtone](#changing-ringtone)
    - [Adjusting Volume](#adjusting-volume)
  - [Usage Examples](#usage-examples)
    - [Triggering the Alarm](#triggering-the-alarm)
    - [Setting a 30-second Alarm with Ringtone 5](#setting-a-30-second-alarm-with-ringtone-5)
  - [Troubleshooting](#troubleshooting)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---

# Tuya ZA03 (Zigbee Siren Alarm) Documentation

## Device Information

- **Manufacturer**: Tuya
- **Model**: ZA03 (Siren alarm)
- **Device ID**: `0xa4c1382fe3d17f3d`
- **Via Device**: `zigbee2mqtt_bridge_0x187a3efffe396264`

## MQTT Topics

### Main State Topic

- **Topic**: `zigbee2mqtt/upstairs_alarm`
- **Payload Example**:

  ```json
  {
    "alarm": "OFF",
    "duration": null,
    "linkquality": 144,
    "ringtone": "ringtone 1",
    "volume": null
  }
  ```

### Availability Topic

- **Topic**: `zigbee2mqtt/bridge/state`
- **Payload**: `{"state": "online"}` (or "offline")

## Discovered Entities

### 1. Alarm Switch

- **Entity ID**: `switch.upstairs_alarm_alarm`
- **Command Topic**: `zigbee2mqtt/upstairs_alarm/set/alarm`
- **State Topic**: `zigbee2mqtt/upstairs_alarm`
- **Value Template**: `{{ value_json.alarm }}`
- **Payloads**:
  - Turn on: `ON`
  - Turn off: `OFF`

### 2. Volume Control

- **Entity ID**: `select.upstairs_alarm_volume`
- **Entity Category**: `config`
- **Command Topic**: `zigbee2mqtt/upstairs_alarm/set/volume`
- **State Topic**: `zigbee2mqtt/upstairs_alarm`
- **Value Template**: `{{ value_json.volume }}`
- **Options**:
  - `low`
  - `medium`
  - `high`
  - `mute`

### 3. Ringtone Selection

- **Entity ID**: `select.upstairs_alarm_ringtone`
- **Command Topic**: `zigbee2mqtt/upstairs_alarm/set/ringtone`
- **State Topic**: `zigbee2mqtt/upstairs_alarm`
- **Value Template**: `{{ value_json.ringtone }}`
- **Options**: 32 preconfigured ringtones (`ringtone 1` through `ringtone 32`)
- **Current Setting**: `ringtone 1`

### 4. Duration Control

- **Entity ID**: `number.upstairs_alarm_duration`
- **Entity Category**: `config`
- **Command Topic**: `zigbee2mqtt/upstairs_alarm/set/duration`
- **State Topic**: `zigbee2mqtt/upstairs_alarm`
- **Value Template**: `{{ value_json.duration }}`
- **Unit of Measurement**: seconds
- **Range**: 1-380 seconds
- **Step**: 1 second

## Device Status Information

The device reports:

- Current alarm state (ON/OFF)
- Selected ringtone
- Link quality indicator
- Duration and volume settings (when configured)

## Configuration Options

### Setting Alarm Duration

1. Through Home Assistant UI using the `number.upstairs_alarm_duration` entity
2. By publishing to `zigbee2mqtt/upstairs_alarm/set/duration` with a value between 1-380

### Changing Ringtone

1. Through Home Assistant UI using the `select.upstairs_alarm_ringtone` entity
2. By publishing to `zigbee2mqtt/upstairs_alarm/set/ringtone` with one of the 32 ringtone options

### Adjusting Volume

1. Through Home Assistant UI using the `select.upstairs_alarm_volume` entity
2. By publishing to `zigbee2mqtt/upstairs_alarm/set/volume` with: `low`, `medium`, `high`, or `mute`

## Troubleshooting

1. **Alarm not sounding**:
   - Check volume is not set to "mute"
   - Verify device power/battery
   - Check link quality (values below 50 may indicate connection issues)

2. **Alarm not stopping**:
   - Send `OFF` command to `zigbee2mqtt/upstairs_alarm/set/alarm`
   - If unresponsive, power cycle the device

3. **Configuration not applying**:
   - Set duration/volume/ringtone before activating alarm
   - Ensure commands are sent to the correct topics
