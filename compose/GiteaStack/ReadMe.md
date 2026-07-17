# GiteaStack

Self-hosted source control and collaboration stack.

## Why This Exists

I wanted a private Git platform I fully own, with a clean workflow for code, issues, and project tracking. I still mirror my entire repos to GitHub, creating a reliable offsite backup and a public-facing portfolio while keeping my primary development environment self-hosted.

## Services

### gitea

- Image: `gitea/gitea:latest`
- Purpose: Git hosting, pull requests, issues, and lightweight project management
- Host ports:
	- `3001` -> `3000` (web UI)
	- `222` -> `22` (SSH Git access)
- Data mounts:
	- `/opt/HomeLab/configs/GiteaStack/gitea` -> `/data`
	- `/mnt/HDDStorage/DockerVolumes/GiteaStack/repositories` -> `/data/git/repositories`

### postgres

- Image: `postgres:16`
- Purpose: persistent Gitea database
- Data mount: `/opt/HomeLab/configs/GiteaStack/postgres`
- Healthcheck: `pg_isready` gates Gitea startup

## Network

- Internal bridge network: `gitea_net`
