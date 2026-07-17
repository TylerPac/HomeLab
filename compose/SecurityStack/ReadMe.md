# SecurityStack

Home security and automation stack.

## Why This Exists

This stack ties cameras and smart-home automation into one system so I can monitor my environment and build reliable event-driven automations.

## Services

### frigate

- Image: `ghcr.io/blakeblackshear/frigate:stable-tensorrt`
- Purpose: NVR, object detection, and camera event processing
- Host ports:
	- `1984` (restream)
	- `5000` (API/UI)
	- `8971` (authenticated UI)
- Media mount: `/mnt/HDDStorage/DockerVolumes/SecurityStack/frigate`
- Config mount: `/opt/HomeLab/configs/SecurityStack/frigate`
- Uses NVIDIA GPU reservation for accelerated inference

### mqtt

- Image: `eclipse-mosquitto:latest`
- Purpose: event bus for Frigate and automation consumers
- Host port: `1883`
- Data/config mounts under SecurityStack config/data/log paths

### homeassistant

- Image: `ghcr.io/home-assistant/home-assistant:stable`
- Purpose: central smart-home automation platform
- Network mode: `host` for broad local network integration
- Config mount: `/opt/HomeLab/configs/SecurityStack/homeassistant`
