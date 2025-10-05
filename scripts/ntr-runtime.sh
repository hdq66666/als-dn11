#!/bin/sh

set -e

SYNC_BIN=${SYNC_BIN:-/usr/local/bin/ntr-sync.sh}
TARGET_HOST=${TARGET_HOST:-git.baimeow.dn11}
TARGET_IP=${TARGET_IP:-172.16.4.70}

log() { printf '[ntr-runtime] %s\n' "$1"; }

ensure_host_mapping() {
    if [ -f /etc/hosts ]; then
        if awk -v ip="$TARGET_IP" -v host="$TARGET_HOST" '($1 == ip) {for (i = 2; i <= NF; ++i) if ($i == host) found = 1} END {exit found ? 0 : 1}' /etc/hosts; then
            return
        fi
    fi

    tmp=$(mktemp)
    if [ -f /etc/hosts ]; then
        awk -v host="$TARGET_HOST" '{keep=1; for (i=2;i<=NF;++i) if ($i==host) {keep=0; break} if (keep) print $0}' /etc/hosts >"$tmp" || true
    fi
    printf '%s %s\n' "$TARGET_IP" "$TARGET_HOST" >>"$tmp"
    cat "$tmp" >/etc/hosts
    rm -f "$tmp"
    log "host entry updated: $TARGET_IP $TARGET_HOST"
}

ensure_host_mapping

if ! "$SYNC_BIN"; then
    log "initial sync failed"
fi

exec /bin/als "$@"
