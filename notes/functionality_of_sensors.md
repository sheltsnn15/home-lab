<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [aliases: []
tags: []](#aliases-%0Atags-)
- [functionality_of_sensors](#functionality_of_sensors)
  - [**Devices & Functionalities:**](#devices--functionalities)
    - [**1. [[SONOFF_SNZB-04P|MQTT_Documents/SONOFF_SNZB-04P.md]] (Door/Window Sensor)**](#1-sonoff_snzb-04pmqtt_documentssonoff_snzb-04pmd-doorwindow-sensor)
    - [**2. SONOFF SNZB-03P (Motion Sensor)**](#2-sonoff-snzb-03p-motion-sensor)
    - [**3. Tuya ZA03 (Siren Alarm)**](#3-tuya-za03-siren-alarm)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---

# functionality_of_sensors

### **Devices & Functionalities:**

#### **1. [[SONOFF_SNZB-04P|MQTT_Documents/SONOFF_SNZB-04P.md]] (Door/Window Sensor)**

- **Contact Sensor** (`binary_sensor.door_contact`)
  - Detects open/closed state of doors/windows.
- **Battery Status** (`sensor.door_battery`)
  - Reports battery percentage.
- **Tamper Detection** (`binary_sensor.door_tamper`)
  - Alerts if someone tries to tamper with the sensor.

#### **2. [[SONOFF_SNZB-03P|MQTT_Documents/SONOFF_SNZB-03P.md]] (Motion Sensor)**

- **Occupancy Sensor** (`binary_sensor.motion_occupancy`)
  - Detects motion (occupancy).
- **Illumination Sensor** (`sensor.motion_illuminance`)
  - Reports light levels in Lux.
- **Battery Status** (`sensor.motion_battery`)
  - Reports battery percentage.

#### **3. [[Tuya_ZA03|MQTT_Documents/Tuya_ZA03.md]] (Siren Alarm)**

- **Alarm Control** (`alarm_control_panel.siren_alarm`)
  - Can be armed/disarmed manually or via automation.
- **Tamper Detection**
  - Alerts if the siren is tampered with.
- **Volume Control** (`number.siren_volume`)
  - Adjusts alarm volume.
- **Ringtone Selection** (`select.siren_ringtone`)
  - Allows selecting different alarm sounds.
- **Duration Setting** (`number.siren_duration`)
  - Defines how long the alarm should sound.
