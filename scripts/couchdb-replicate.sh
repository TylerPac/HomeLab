#!/usr/bin/env bash
set -euo pipefail

# Bidirectional CouchDB replication between the bridge DB (obsidianvault)
# and the DB used by Obsidian clients (obsidianknowledge).
# The _replicator DB is not usable on this deployment (endpoint restrictions),
# so we run incremental one-shot replications on a timer instead.

LOCK_FILE=/tmp/couchdb-replicate.lock
exec 9>"$LOCK_FILE"
flock -n 9 || exit 0

# Credentials come from the stack env file (gitignored); never hardcode them.
ENV_FILE=/opt/HomeLab/compose/KnowledgeStack/.env
# shellcheck disable=SC1090
set -a; source "$ENV_FILE"; set +a

AUTH="${COUCHDB_ADMIN_USER}:${COUCHDB_ADMIN_PASSWORD}"
BASE='http://127.0.0.1:5984'

replicate() {
	local src="$1" tgt="$2"
	docker run --rm --network container:couchdb curlimages/curl:8.8.0 \
		-sS -m 300 -u "$AUTH" -H 'Content-Type: application/json' \
		-d "{\"source\":\"http://${AUTH}@127.0.0.1:5984/${src}\",\"target\":\"http://${AUTH}@127.0.0.1:5984/${tgt}\",\"create_target\":false,\"continuous\":false}" \
		"$BASE/_replicate" | head -c 400
	echo
}

replicate obsidianvault obsidianknowledge
replicate obsidianknowledge obsidianvault
