#!/usr/bin/env bash
set -euo pipefail

LOCK_FILE=/tmp/goodnotes-ingest.lock
INBOX=/mnt/HDDStorage/DockerVolumes/KnowledgeStack/GoodNotes/webdav-inbox
DEST=/mnt/HDDStorage/DockerVolumes/KnowledgeStack/ObsidianVault/SirPacsterVault/GoodNotes

exec 9>"$LOCK_FILE"
flock -n 9 || exit 0

mkdir -p "$INBOX" "$DEST"

# One-way ingest only: checksum mode catches content updates even when source
# mtimes are unchanged. Never delete from destination.
# GoodNotes exports under Backup/, but vault should store category folders
# directly under GoodNotes/ (for example SWE/, Game Development/).
# We ingest from both legacy and new WebDAV export roots; new inbox data is
# applied last so it wins when the same file differs.
CHANGES=""
if command -v rsync >/dev/null 2>&1; then
	# NOTE: legacy Backup/ dir was backfilled already; syncing it every run
	# caused endless oscillation with the inbox copy of identical files.
	if [[ -d "$INBOX/Backup" ]]; then
		OUT=$(rsync -r --checksum --human-readable --itemize-changes \
			"$INBOX/Backup/" "$DEST/" 2>/dev/null) || true
		echo "$OUT"
		CHANGES+="$OUT"
	else
		OUT=$(rsync -r --checksum --human-readable --itemize-changes \
			"$INBOX/" "$DEST/" 2>/dev/null) || true
		echo "$OUT"
		CHANGES+="$OUT"
	fi
else
	if [[ -d "$INBOX/Backup" ]]; then
		cp -au "$INBOX/Backup/." "$DEST/"
	else
		cp -au "$INBOX/." "$DEST/"
	fi
	CHANGES="unknown"
fi

# The vault lives on a FUSE (NTFS) mount where inotify does not deliver
# events, so the livesync-bridge daemon never notices new files on its own.
# Restart the bridge when files were actually transferred (rsync itemize
# lines starting with '>') so its startup mirror scan pushes them to CouchDB.
if echo "$CHANGES" | grep -q '^>'; then
	echo "Ingest changed files; restarting livesync-bridge to trigger rescan"
	docker restart livesync-bridge >/dev/null 2>&1 || true
	# Bridge scan takes ~30-60s; schedule a replication run right after it
	# finishes so changes reach obsidianknowledge without waiting for the
	# next timer tick.
	systemd-run --user --on-active=75s --timer-property=AccuracySec=5s \
		--unit="couchdb-replicate-followup-$(date +%s)" \
		systemctl --user start couchdb-replicate.service >/dev/null 2>&1 || true
fi