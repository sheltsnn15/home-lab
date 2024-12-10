### Hardware Interactions

1. Central Controller: Raspberry Pi 4B

- Role: Central brain for coordinating all devices.
- Functions:
  - Manages Zigbee communication through the USB dongle.
  - Handles motion-triggered lighting, radiator heating schedules, and manual overrides.
  - Integrates with the Tapo Camera for security notifications.
  - Periodically fetches sunrise/sunset times via the API.

2. Zigbee USB Dongle (Silicon Labs EFR32MG21)

- Role: Communication gateway for Zigbee devices.
- Interaction:
  - Connects motion sensors, smart bulbs, and radiator valves to the Raspberry Pi.
- Tasks:
  - Relay commands and data between Zigbee devices and the Raspberry Pi.

3. Motion Sensors (SONOFF SNZB-03)

- Role: Detect motion to trigger lighting events.
- Interaction:
  - Sends motion detection signals to the Raspberry Pi via Zigbee.
- Tasks:
  - Trigger lights ON when motion is detected.
  - Allow lights to turn OFF after a period of inactivity.

4. Smart Bulbs (Innr Zigbee GU10 LED Bulbs)

- Role: Lighting automation for corridors and stairs.
- Interaction:
  - Receive ON/OFF or dimming commands from the Raspberry Pi via Zigbee.
- Tasks:
  - Illuminate corridors/stairs upon motion detection.
  - Turn OFF lights after a specified timeout of no motion.
  - Allow manual ON/OFF control from the app, overriding automation schedules.

5. Zigbee Thermostatic Radiator Valve (SONOFF TRVZB)

- Role: Manage room heating.
- Interaction:
  - Receive scheduled temperature adjustments from the Raspberry Pi via Zigbee.
  - Allow manual ON/OFF control from the app, overriding schedules.
- Tasks:
  - Adjust room temperatures based on predefined schedules.
  - Operate independently of motion sensors or sunrise/sunset API data.
  - Enable manual ON/OFF control via the app.
- Placement: Bedrooms, kitchen, and dining areas only.

6. Tapo 2K Rechargeable Battery Camera (TC82)

- Role: Provide home security with AI-based motion detection.
- Interaction:
  - Send motion alerts to the Raspberry Pi via API.
  - Enable notifications for relevant events without activating alarms.
- Tasks:
  - Monitor indoor/outdoor activity and notify the Raspberry Pi.
  - Log security events for later review.

7. Sunrise/Sunset API

- Role: Provide daylight-based schedule data for lighting automation.
- Interaction:
  - The Raspberry Pi fetches and updates daily sunrise and sunset times.
- Tasks:
  - Adjust lighting schedules to operate only during non-daylight hours (sunset to sunrise).
