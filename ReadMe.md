# HomeLab

This repository is my personal homelab journey: a place where I can learn by building real systems that I use every day.

I grew up loving software and computers. This homelab is that passion turning into infrastructure, automation, and self-hosted services I control.

## Hardware

- CPU: Intel Core i9-10850K
- GPU 1: NVIDIA RTX 3080
- GPU 2: NVIDIA GTX 1070 Ti
- RAM: 64 GB DDR4 @ 3333 MHz
- Host OS: Linux

## Why I Built This

- Learn production-style ops by running real services at home
- Own my data, media, notes, and source code
- Build practical skills in Docker, networking, security, and automation
- Create a platform that grows with me over time

This is not just a "lab". It is my software evolution from tinkering to operating a full self-hosted stack.

## Project Layout

The repo is organized by stack:

- `compose/AIStack`
- `compose/GiteaStack`
- `compose/KnowledgeStack`
- `compose/MediaStack`
- `compose/Networking`
- `compose/PhotoStack`
- `compose/SecurityStack`

Persistent data and config live outside compose files:

- Docker volumes/data: `/mnt/HDDStorage/DockerVolumes`
- Service configs/secrets: `/opt/HomeLab/configs` and `/opt/HomeLab/secrets`

## Stacks Overview

### AIStack

Local AI inference and private metasearch.

- `llama-cpp` with CUDA for local LLM serving
- `searxng` for private aggregated search

Read more: [compose/AIStack/ReadMe.md](compose/AIStack/ReadMe.md)

### GiteaStack

Self-hosted Git platform for private development workflow.

- `gitea` for repositories, issues, and code collaboration
- `postgres` for persistent database storage

Read more: [compose/GiteaStack/ReadMe.md](compose/GiteaStack/ReadMe.md)

### KnowledgeStack

Personal knowledge infrastructure for notes and files.

- `webdav` for GoodNotes sync/workflow
- `minio` for S3-compatible object storage

Read more: [compose/KnowledgeStack/ReadMe.md](compose/KnowledgeStack/ReadMe.md)

### MediaStack

Automated media acquisition and streaming stack.

- `gluetun` + `qbittorrent` for VPN-routed downloads
- `jackett`, `radarr`, `sonarr`, `readarr` for index + automation
- `jellyfin` for media streaming/transcoding
- `seerr` for request management
- `flaresolverr` for anti-bot compatibility in index workflows

Read more: [compose/MediaStack/ReadMe.md](compose/MediaStack/ReadMe.md)

### Networking

Core network services and ingress.

- `pihole` for DNS filtering/ad blocking
- `traefik` for reverse proxy and routing
- `cloudflared` for secure external tunnel access

Read more: [compose/Networking/ReadMe.md](compose/Networking/ReadMe.md)

### PhotoStack

Self-hosted photo management and AI features.

- `immich-server` as the main photo app
- `immich-machine-learning` with CUDA acceleration
- `immich-postgres` and `immich-redis` as backing services

Read more: [compose/PhotoStack/ReadMe.md](compose/PhotoStack/ReadMe.md)

### SecurityStack

Home monitoring and automation security foundation.

- `frigate` NVR with GPU acceleration
- `mqtt` event bus
- `homeassistant` for smart-home orchestration

Read more: [compose/SecurityStack/ReadMe.md](compose/SecurityStack/ReadMe.md)

