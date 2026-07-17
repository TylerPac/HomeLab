# KnowledgeStack

Knowledge and file-sync stack for notes, documents, and object storage.

## Why This Exists

This stack keeps my knowledge workflow local-first and self-hosted, while still giving me sync and flexible storage options. My main use case is syncing Obsidian and GoodNotes across all my devices while keeping my data secure and local.

## Services

### webdav

- Image: `hacdias/webdav`
- Container name: `goodnotes-webdav`
- Purpose: WebDAV endpoint for GoodNotes and compatible clients
- Host port: `8085` -> container `80`
- Data mount: `/mnt/HDDStorage/DockerVolumes/KnowledgeStack/GoodNotes`

### minio

- Image: `minio/minio:RELEASE.2025-04-22T22-12-26Z`
- Purpose: S3-compatible object storage for notes and assets
- Host ports:
	- `9000` (S3 API)
	- `9090` (MinIO console)
- Data mount: `/mnt/HDDStorage/DockerVolumes/KnowledgeStack/MinIO`

## Start

From `/opt/HomeLab`:

```bash
docker compose -f compose/KnowledgeStack/docker-compose.yml up -d --build
```
