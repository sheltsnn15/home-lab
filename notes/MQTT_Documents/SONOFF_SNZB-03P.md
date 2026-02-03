
---

# SONOFF SNZB-03P (Zigbee PIR Sensor) Documentation

## Device Information

- **Manufacturer**: SONOFF
- **Model**: SNZB-03P (Zigbee PIR sensor)
- **Hardware Version**: 0
- **Software Version**: 2.2.1
- **Zigbee2MQTT Version**: 2.1.3
- **Device ID**: `0x0ceff6fffe1818fa`
- **Via Device**: `zigbee2mqtt_bridge_0x187a3efffe396264`

## MQTT Topics

### Main State Topic

- **Topic**: `zigbee2mqtt/ms_dining`
- **Payload Example**:

  ```json
  {
    "battery": 100,
    "illumination": "bright",
    "linkquality": 168,
    "motion_timeout": 17,
    "occupancy": false,
    "update": {
      "installed_version": 8705,
      "latest_version": 8705,
      "state": "idle"
    },
    "voltage": 3000
  }
  ```

### Availability Topic

- **Topic**: `zigbee2mqtt/bridge/state`
- **Payload**: `{"state": "online"}` (or "offline")

## Discovered Entities

### 1. Occupancy (Motion) Sensor

- **Entity ID**: `binary_sensor.ms_dining_occupancy`
- **Device Class**: `occupancy`
- **State Topic**: `zigbee2mqtt/ms_dining`
- **Value Template**: `{{ value_json.occupancy }}`
- **Payloads**:
  - Motion detected: `true`
  - No motion: `false`

### 2. Motion Timeout Configuration

- **Entity ID**: `number.ms_dining_motion_timeout`
- **Type**: Number configuration
- **Command Topic**: `zigbee2mqtt/ms_dining/set/motion_timeout`
- **State Topic**: `zigbee2mqtt/ms_dining`
- **Value Template**: `{{ value_json.motion_timeout }}`
- **Range**: 5-60 (seconds)
- **Current Setting**: 17 seconds

### 3. Illumination Sensor

- **Entity ID**: `sensor.ms_dining_illumination`
- **State Topic**: `zigbee2mqtt/ms_dining`
- **Value Template**: `{{ value_json.illumination }}`
- **Possible Values**: `bright`, `dark` (or other illumination states)

### 4. Battery Level Sensor

- **Entity ID**: `sensor.ms_dining_battery`
- **Device Class**: `battery`
- **Entity Category**: `diagnostic`
- **State Topic**: `zigbee2mqtt/ms_dining`
- **Value Template**: `{{ value_json.battery }}`
- **Unit of Measurement**: `%`

### 5. Firmware Update

- **Entity ID**: `update.ms_dining`
- **Device Class**: `firmware`
- **Entity Category**: `config`
- **State Topic**: `zigbee2mqtt/ms_dining`
- **Command Topic**: `zigbee2mqtt/bridge/request/device/ota_update/update`
- **Payload Install**: `{"id": "0x0ceff6fffe1818fa"}`

## Device Status Information

The device regularly reports:

- Battery level (percentage and voltage)
- Motion detection status
- Illumination level
- Current motion timeout setting
- Link quality indicator
- Firmware update status

## Typical Values

- **Battery**: 100% (voltage ~3.0V when full)
- **Link Quality**: 150-180 (higher is better)
- **Motion Timeout**: 17 seconds (configurable)
- **Firmware Version**: 8705
- **Illumination**: Typically reports "bright" in your environment

## Configuration Options

### Adjusting Motion Timeout

You can change the motion detection timeout period (how long the sensor reports motion after detecting movement):

1. Through Home Assistant UI using the `number.ms_dining_motion_timeout` entity
2. By publishing to `zigbee2mqtt/ms_dining/set/motion_timeout` with a value between 5-60

## Troubleshooting

1. **Motion not detected**:
   - Check illumination level (may not trigger in bright light if configured that way)
   - Verify battery level
   - Ensure the sensor has a clear view of the area

2. **False motion alerts**:
   - Adjust sensor positioning
   - Check for sources of heat or moving objects in detection range

3. **Update issues**:
   - Trigger updates when motion is recently detected (device is awake)
   - Ensure stable network connection during update

## Zigbee2MQTT Integration

This PIR sensor is fully integrated with Zigbee2MQTT, providing automatic discovery and configuration in Home Assistant through MQTT discovery.
