# Networking

Core network, DNS, and ingress stack.

## Why This Exists

This stack gives the homelab a clean network foundation: local DNS control, reverse proxy routing, and secure external access.

## Services

### pihole

- Image: `pihole/pihole:latest`
- Purpose: DNS filtering and ad blocking for the network
- Host ports:
	- `53/tcp`
	- `53/udp`
	- `8081` -> `80` (web admin)
- Config mount: `/opt/HomeLab/configs/Networking/etc-pihole`

### traefik

- Image: `traefik:v3.7`
- Purpose: reverse proxy and service routing
- Host port: `80`
- Docker socket mounted read-only for dynamic service discovery

### cloudflared

- Image: `cloudflare/cloudflared:latest`
- Purpose: Cloudflare Tunnel ingress without exposing direct inbound ports
- Depends on `traefik`

## Network

- External docker network: `proxy`
