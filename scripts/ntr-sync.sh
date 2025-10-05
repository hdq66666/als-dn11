#!/bin/sh

set -eu

BASE_URL="https://git.baimeow.dn11/hdq66666/ntr/raw/branch/main"
NTR_HOME=${NTR_HOME:-/opt/ntr}
FILES="geofeed.csv ptr.csv"

log() {
    printf '[ntr-sync] %s\n' "$1"
}

fetch_file() {
    file="$1"
    tmp=$(mktemp)
    if ! wget --no-check-certificate -O "$tmp" "$BASE_URL/$file"; then
        log "failed to download $file"
        rm -f "$tmp"
        return 1
    fi

    dest="$NTR_HOME/$file"
    mv "$tmp" "$dest"
    chmod 0644 "$dest"
    log "updated $file"
    return 0
}

ensure_placeholder() {
    file="$1"
    dest="$NTR_HOME/$file"
    if [ -f "$dest" ]; then
        return
    fi
    printf '# placeholder created %s\n' "$(date -u +%FT%TZ)" >"$dest"
    chmod 0644 "$dest"
    log "created placeholder for $file"
}

update_config() {
    cfg="$NTR_HOME/nt_config.yaml"
    geopath="$NTR_HOME/geofeed.csv"
    ptrpath="$NTR_HOME/ptr.csv"

    if [ ! -f "$cfg" ]; then
        cat <<EOF_CFG >"$cfg"
geofeedpath: $geopath
ptrpath: $ptrpath
EOF_CFG
        log "created nt_config.yaml"
        return
    fi

    sed -i '/^[[:space:]]*[Gg][Ee][Oo][Ff][Ee][Ee][Dd][Pp][Aa][Tt][Hh]:/d' "$cfg"
    sed -i '/^[[:space:]]*[Pp][Tt][Rr][Pp][Aa][Tt][Hh]:/d' "$cfg"
    printf 'geofeedpath: %s\nptrpath: %s\n' "$geopath" "$ptrpath" >>"$cfg"
    log "updated nt_config.yaml paths"
}

mkdir -p "$NTR_HOME"
status=0

for f in $FILES; do
    if ! fetch_file "$f"; then
        status=1
    fi
done

for f in $FILES; do
    ensure_placeholder "$f"
done

update_config

exit $status
