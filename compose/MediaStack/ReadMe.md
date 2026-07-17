# MediaStack

End-to-end media automation and streaming stack.

## Why This Exists

I built this stack to automate discovery, downloads, organization, and playback while keeping full control of my media library.

## Legal Personal-Use Policy

This stack is for legal, personal use only.

- I only manage media I personally own, have licensed, or that is openly distributed.
- I do not use this setup to pirate content.
- Typical sources are personal backups from discs I own, personal digital purchases, and free/openly licensed media.

## How I Use It Legally

1. I acquire media through legal sources I own or have rights to use.
2. I store that media in my local library paths on my own hardware.
3. Radarr, Sonarr, and Readarr monitor and organize files into clean folders.
4. Jellyfin reads the organized library and serves it to my devices.
5. Seerr is used as a request and workflow front end for my household.

The result is a clean home media system focused on convenience, organization, and lawful personal access.

## Services

### gluetun

- Image: `qmcgaw/gluetun:latest`
- Purpose: VPN gateway (NordVPN/OpenVPN) for protected download traffic
- Host port: `8080` (qBittorrent Web UI forwarded through gluetun)

### qbittorrent

- Image: `lscr.io/linuxserver/qbittorrent:latest`
- Purpose: torrent client routed through `gluetun`
- Network mode: `service:gluetun`
- Data mount: `/mnt/HDDStorage/DockerVolumes/MediaStack/qbittorrent/downloads`

### jackett

- Image: `lscr.io/linuxserver/jackett:latest`
- Purpose: source adapter service used by Radarr/Sonarr/Readarr integrations
- Host port: `19117` -> `9117`

### radarr

- Image: `lscr.io/linuxserver/radarr:latest`
- Purpose: movie automation and library management
- Host port: `17878` -> `7878`

### sonarr

- Image: `lscr.io/linuxserver/sonarr:latest`
- Purpose: TV/anime automation and library management
- Host port: `18989` -> `8989`

### readarr

- Image: `ghcr.io/faustvii/readarr:latest`
- Purpose: ebook/audiobook acquisition and organization
- Host port: `18787` -> `8787`

### jellyfin

- Image: `lscr.io/linuxserver/jellyfin:latest`
- Purpose: media streaming server
- Host ports:
	- `8097` -> `8096`
	- `8920` -> `8920`
	- `7359/udp` -> `7359/udp`
- Uses NVIDIA GPU device reservation for hardware acceleration

### seerr

- Image: `ghcr.io/seerr-team/seerr:latest`
- Purpose: media request portal
- Host port: `15055` -> `5055`

### flaresolverr

- Image: `ghcr.io/flaresolverr/flaresolverr:latest`
- Purpose: anti-bot challenge handling for automation workflows
- Host port: `8191`

## Network

- Bridge network: `media_net`
