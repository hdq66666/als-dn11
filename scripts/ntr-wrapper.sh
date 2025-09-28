#!/bin/sh

set -eu

NTR_HOME=${NTR_HOME:-/opt/ntr}
SYNC_BIN=${SYNC_BIN:-/usr/local/bin/ntr-sync.sh}

log() {
    printf '[ntr-wrapper] %s\n' "$1" >&2
}

mkdir -p "$NTR_HOME"

if [ ! -f "$NTR_HOME/geofeed.csv" ] || [ ! -f "$NTR_HOME/ptr.csv" ]; then
    log "missing DN42 datasets, triggering sync"
    if ! "$SYNC_BIN"; then
        log "sync command failed, falling back to placeholders"
    fi
fi

for data_file in geofeed.csv ptr.csv; do
    path="$NTR_HOME/$data_file"
    if [ ! -f "$path" ]; then
        : >"$path"
    fi
done

cd "$NTR_HOME"
exec /usr/local/bin/nexttrace --dn42 "$@"
