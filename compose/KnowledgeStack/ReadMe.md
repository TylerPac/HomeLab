# KnowledgeStack

Knowledge and file-sync stack for notes and documents.

## Why This Exists

This stack keeps my knowledge workflow local-first and self-hosted. My main use case is syncing Obsidian and GoodNotes across all my devices (Ubuntu desktop, Windows, iPad) while keeping my data secure and local, without needing any Obsidian app running on the homelab.

## Current Architecture

- CouchDB is the single synchronization authority for Obsidian (Self-hosted LiveSync plugin on every device).
- GoodNotes auto-backs-up into an external WebDAV inbox; it is a one-way external source and never receives writes back.
- A host-side ingest timer copies new/changed GoodNotes exports from the inbox into the vault's `GoodNotes/` folder.
- A headless LiveSync bridge container pushes on-disk vault changes into CouchDB, so devices stay in sync even when no Obsidian client is open on the homelab.
- A host-side replication timer keeps the two CouchDB databases (`obsidianvault`, used by the bridge, and `obsidianknowledge`, used by the Obsidian clients) mirrored in both directions.

### Data Flow

```
GoodNotes (iPad)
  └─ WebDAV backup ──► webdav container ──► webdav-inbox/  (external inbox)
                                               │
                              goodnotes-ingest.timer (1 min, one-way rsync)
                                               ▼
                          ObsidianVault/SirPacsterVault/GoodNotes/
                                               │
                            livesync-bridge (rescan on ingest change)
                                               ▼
                                    CouchDB: obsidianvault
                                               │
                          couchdb-replicate.timer (1 min, both ways)
                                               ▼
                                  CouchDB: obsidianknowledge
                                               │
                             Self-hosted LiveSync plugin (pull/live)
                                               ▼
                              Desktop / iPad / other Obsidian clients
```

## Services

### webdav

- Image: `hacdias/webdav`
- Container name: `goodnotes-webdav`
- Purpose: WebDAV endpoint for GoodNotes automatic backups
- Host port: `8085` -> container `80`
- Data mount: `/mnt/HDDStorage/DockerVolumes/KnowledgeStack/GoodNotes/webdav-inbox`
- External route: `https://goodnotes.tylerpac.dev`

### couchdb

- Image: `couchdb:3.4`
- Container name: `couchdb`
- Purpose: synchronization authority for the Obsidian vault
- Databases:
	- `obsidianknowledge` — used by all Obsidian clients (LiveSync plugin)
	- `obsidianvault` — used by the headless bridge; mirrored to/from `obsidianknowledge` by the replication timer
- Data mount: `/mnt/HDDStorage/DockerVolumes/KnowledgeStack/CouchDB/data`
- Config mount: `/opt/HomeLab/configs/KnowledgeStack/couchdb/local.ini` (CORS, 200 MB max document size)
- External route: `https://couchdb.tylerpac.dev`

### livesync-bridge

- Image: `ghcr.io/vrtmrz/livesync-cli:latest`
- Container name: `livesync-bridge`
- Purpose: headless LiveSync client; mirrors the on-disk vault into CouchDB so no homelab Obsidian app is needed
- State mount: `/mnt/HDDStorage/DockerVolumes/KnowledgeStack/LiveSyncBridge/state` -> `/data`
- Vault mount: `/mnt/HDDStorage/DockerVolumes/KnowledgeStack/ObsidianVault/SirPacsterVault` -> `/vault`
- Note: the vault lives on a FUSE (NTFS) mount which does not deliver inotify events, so the bridge cannot detect changes live; the ingest job restarts the container after copying files, which triggers a full mirror rescan on startup.

## Host-Side Automation (systemd user units)

Unit sources live in `/opt/HomeLab/scripts/` and are installed to `~/.config/systemd/user/`.

### goodnotes-ingest (`.timer` every minute)

`/opt/HomeLab/scripts/goodnotes-ingest.sh`

- One-way, checksum-based rsync from the WebDAV inbox into the vault `GoodNotes/` folder; never deletes destination files.
- Flattens the GoodNotes `Backup/` folder so the vault holds category folders directly (for example `GoodNotes/SWE/`).
- When files were actually copied, restarts `livesync-bridge` (FUSE watcher workaround) and schedules a follow-up replication run ~75 s later so changes reach clients quickly.

### couchdb-replicate (`.timer` every minute)

`/opt/HomeLab/scripts/couchdb-replicate.sh`

- Runs incremental one-shot CouchDB `_replicate` calls in both directions between `obsidianvault` and `obsidianknowledge`.
- Credentials are sourced from the stack `.env` file at runtime; nothing is hardcoded.
- Uses `flock` to prevent overlapping runs.

Enable after changes:

```bash
cp /opt/HomeLab/scripts/{goodnotes-ingest,couchdb-replicate}.{service,timer} ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now goodnotes-ingest.timer couchdb-replicate.timer
```

## Required Environment

Set these values in `/opt/HomeLab/compose/KnowledgeStack/.env` (gitignored — use LF line endings, CRLF breaks shell sourcing):

```bash
WEBDAV_USER=<webdav-user>
WEBDAV_PASSWORD=<webdav-password>
COUCHDB_ADMIN_USER=<couchdb-admin-user>
COUCHDB_ADMIN_PASSWORD=<couchdb-admin-password>
COUCHDB_SECRET=<long-random-secret>
```

## Client Configuration Notes

- Every Obsidian device uses the Self-hosted LiveSync plugin pointed at `https://couchdb.tylerpac.dev`, database `obsidianknowledge`, same credentials/passphrase.
- Set the plugin's maximum sync file size to 200 MB on each device (default 50 MB skips large PDFs); the server-side limit is already 200 MB.
- Do not run any other sync tool (Remotely Save, iCloud, Obsidian Sync) against this vault.
- GoodNotes files are managed in GoodNotes: deleting an exported PDF inside Obsidian will not stick, because ingest restores it from the inbox. Delete it in GoodNotes instead.
- iOS limitation: Obsidian on iPad only pulls while the app is open in the foreground.

## Start

From `/opt/HomeLab`:

```bash
docker compose -f compose/KnowledgeStack/docker-compose.yml up -d
```
