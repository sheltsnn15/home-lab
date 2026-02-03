<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [1. Alarm Triggering via MQTT](#1-alarm-triggering-via-mqtt)
- [2. Ringtone Mapping](#2-ringtone-mapping)
- [3. Escalation Logic](#3-escalation-logic)
- [4. Handling Alarm Duration](#4-handling-alarm-duration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### 1. Alarm Triggering via MQTT

- When a door opens while armed → **Send MQTT: `alarm/trigger/door`**
- When motion is detected while armed → **Send MQTT: `alarm/trigger/motion`**
- When tamper is detected → **Send MQTT: `alarm/trigger/tamper`**

Each siren listens for these messages and plays a different ringtone.

### 2. Ringtone Mapping

- **Door open** → `ringtone 3`
- **Motion detected** → `ringtone 5`
- **Tamper detected** → `ringtone 7`
- **Escalation (repeat motion in 30 sec)** → Increase volume & switch to `ringtone 10`

### 3. Escalation Logic

- If motion is detected twice in 30 seconds → Change ringtone & increase volume.

### 4. Handling Alarm Duration

- Default: 60 seconds.
- If escalation occurs, extend to 120 seconds.
