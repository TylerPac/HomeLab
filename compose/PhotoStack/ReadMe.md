# PhotoStack

Self-hosted photo and video management with AI features.

## Why This Exists

I wanted a private photo platform with modern search, timeline, and machine-learning features without relying on cloud lock-in.

## Services

### immich-server

- Image: `ghcr.io/immich-app/immich-server:release`
- Purpose: Immich API and web service
- Host port: `2283`
- Data mount: `/mnt/HDDStorage/DockerVolumes/PhotoStack/Immich`

### immich-machine-learning

- Image: `ghcr.io/immich-app/immich-machine-learning:release-cuda`
- Purpose: ML tasks such as embeddings and face/object processing
- Uses NVIDIA GPU reservation for acceleration
- Cache mount: `/opt/HomeLab/configs/PhotoStack/immich-machine-learning`

### immich-postgres

- Image: `ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0`
- Purpose: Immich metadata database
- Data mount: `/opt/HomeLab/configs/PhotoStack/immich-postgres`

### immich-redis

- Image: `redis:7`
- Purpose: caching and queue support
- Data mount: `/opt/HomeLab/configs/PhotoStack/immich-redis`
