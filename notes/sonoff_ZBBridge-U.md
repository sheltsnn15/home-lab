<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Turning SONOFF ZBBridge-P into a Zigbee Repeater](#turning-sonoff-zbbridge-p-into-a-zigbee-repeater)
  - [Goal](#goal)
  - [Overview](#overview)
  - [Hardware and Tools](#hardware-and-tools)
  - [Step-by-Step Summary](#step-by-step-summary)
    - [1. Flash Tasmota to ZBBridge-P](#1-flash-tasmota-to-zbbridge-p)
    - [2. Access Tasmota Web UI](#2-access-tasmota-web-ui)
    - [3. Configure GPIO Pins (in Tasmota UI)](#3-configure-gpio-pins-in-tasmota-ui)
    - [4. Upload and Flash Router Firmware](#4-upload-and-flash-router-firmware)
    - [5. Flash Successful](#5-flash-successful)
    - [6. Deploy as Zigbee Router](#6-deploy-as-zigbee-router)
  - [Verifying It's Working](#verifying-its-working)
  - [References](#references)
  - [Tips & Gotchas](#tips--gotchas)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---

# Turning SONOFF ZBBridge-P into a Zigbee Repeater

## Goal

Use the SONOFF ZBBridge-P as a **Zigbee router** to extend Zigbee2MQTT’s coverage in a house with dead zones, using a Raspberry Pi as the main coordinator.

## Overview

1. **Flashed Tasmota firmware** to ESP32 over UART
2. **Uploaded Zigbee router firmware (.hex)** to the device via Tasmota Web UI
3. **Entered BSL (Bootloader) mode** on the Zigbee chip
4. **Flashed the CC2652 Zigbee chip** with router firmware using Berry scripts
5. **Deployed the device** in a low-signal area as a standalone Zigbee router

## Hardware and Tools

| Item                            | Purpose                            |
| ------------------------------- | ---------------------------------- |
| SONOFF ZBBridge-P               | Zigbee repeater hardware           |
| FT232RL USB-to-TTL adapter      | UART flashing of ESP32             |
| Jumper wires (female-female)    | Connection to debug header         |
| Windows 11 laptop               | Flashing via Tasmota Web UI        |
| Raspberry Pi 4B                 | Runs Zigbee2MQTT + Home Assistant  |
| 4x protected 18650 Li-ion cells | Power source for mobile deployment |

## Step-by-Step Summary

### 1. Flash Tasmota to ZBBridge-P

- Open the device, connect FTDI adapter:

  - `TX ↔ RX`, `RX ↔ TX`, `GND ↔ GND`, `3.3V ↔ 3.3V`, `GPIO0 ↔ GND`
- Use [Tasmota Web Installer](https://tasmota.github.io/install/) or Tasmotizer to flash:

  - `tasmota32-zbbrdgpro.factory.bin`

### 2. Access Tasmota Web UI

- Connect to `tasmota_XXXXXX` Wi-Fi AP
- Enter home Wi-Fi credentials
- Navigate to device IP via browser

### 3. Configure GPIO Pins (in Tasmota UI)

Go to **Configuration → Configure Module**, and set:

| GPIO   | Function       |
| ------ | -------------- |
| GPIO15 | Zigbee Rst (1) |
| GPIO22 | Zigbee Rts (2) |
| GPIO19 | Zigbee Tx      |
| GPIO23 | Zigbee Rx      |

Save and **restart the device**.

### 4. Upload and Flash Router Firmware

- Download [router firmware `.hex`](https://github.com/zigbee2mqtt/hardware/blob/master/routers/sonoff/firmware/SonoffZBPro_router_20220125.hex)
- Upload it via **Tasmota Web UI → Firmware Upgrade → Choose File**
- Open **Console**, run:

```berry
import sonoff_zb_pro_flasher as cc
cc.load("SonoffZBPro_router_20220125.hex")
cc.check()
cc.flash()
```

If flash fails with `protocol_error`, run this to enter BSL manually:

```berry
`gpio.set(22, 0)
gpio.set(15, 0)
delay(10)
gpio.set(15, 1)
delay(100)
gpio.set(22, 1)`
```

Then retry:

```berry
import cc2652_flasher as zf
zf.start(true)
zf.ping()
zf.flash_erase()
```

Retry flashing the `.hex`.

### 5. Flash Successful

Log should show:

```
FLH: Flashing completed: OK
FLH: Flash crc32 0x000000 - 0x2FFFF = bytes('XXXXXXXX')
```

This means the Zigbee chip is now a router. Tasmota will log:

```
ZIG: Abort
ZIG: Stopping (99)
```

Indicating it's no longer a coordinator.

### 6. Deploy as Zigbee Router

- Power with USB
- Place in Zigbee dead zone
- Enable **Permit Join** in Zigbee2MQTT
- Optional: restart end devices nearby

## Verifying It's Working

- Zigbee2MQTT Web UI → **Map**
- Click “Update”
- Look for:

  - A new unnamed node
  - Routes from nearby sensors/devices through it

## References

- Tasmota flashing: [https://tasmota.github.io/install](https://tasmota.github.io/install)
- Zigbee router firmware: [ZBPro Router .hex](https://github.com/zigbee2mqtt/hardware/tree/master/routers/sonoff/firmware)
- Zigbee2MQTT: [https://www.zigbee2mqtt.io](https://www.zigbee2mqtt.io)
- BSL explanation (Texas Instruments): [https://www.ti.com/lit/ug/swra466f/swra466f.pdf](https://www.ti.com/lit/ug/swra466f/swra466f.pdf)

## Tips & Gotchas
