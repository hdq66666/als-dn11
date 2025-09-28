#!/bin/sh

set -e

SYNC_BIN=${SYNC_BIN:-/usr/local/bin/ntr-sync.sh}
CRON_FILE=${CRON_FILE:-/etc/crontabs/root}
LOG_FILE=${LOG_FILE:-/var/log/ntr-sync.log}
CRON_SCHEDULE="*/30 * * * *"

log() { printf '[ntr-runtime] %s\n' "$1"; }

mkdir -p "$(dirname "$LOG_FILE")"
: >"$LOG_FILE"

if ! "$SYNC_BIN"; then
    log "initial sync failed"
fi

cron_line="$CRON_SCHEDULE $SYNC_BIN >>$LOG_FILE 2>&1"
if [ -f "$CRON_FILE" ]; then
    if grep -F "$SYNC_BIN" "$CRON_FILE" >/dev/null 2>&1; then
        tmp=$(mktemp)
        sed "s|.*$SYNC_BIN.*|$cron_line|" "$CRON_FILE" >"$tmp"
        cat "$tmp" >"$CRON_FILE"
        chmod 600 "$CRON_FILE"
        rm -f "$tmp"
    else
        printf '%s\n' "$cron_line" >>"$CRON_FILE"
        chmod 600 "$CRON_FILE"
    fi
else
    printf '%s\n' "$cron_line" >"$CRON_FILE"
    chmod 600 "$CRON_FILE"
fi

if command -v crond >/dev/null 2>&1; then
    crond -b -l 2
else
    log "crond not found"
fi

exec /bin/als "$@"
