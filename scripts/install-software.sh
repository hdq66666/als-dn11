#!/bin/sh

set -eu

NEXTTRACE_URL="https://alist.teno.dn11/d/local/nexttrace_dn11/nexttrace_linux_amd64"
NEXTTRACE_BIN="/usr/local/bin/nexttrace"

error() {
    printf '%s\n' "$1" >&2
}

download_nexttrace() {
    local arch tmp
    arch=$(uname -m)
    case "$arch" in
        x86_64|amd64)
            tmp=$(mktemp)
            ;;
        *)
            error "Unsupported architecture for nexttrace: $arch"
            exit 1
            ;;
    esac

    printf 'Download %s to %s\n' "$NEXTTRACE_URL" "$NEXTTRACE_BIN"
    if ! wget --no-check-certificate -O "$tmp" "$NEXTTRACE_URL"; then
        error "Failed to download nexttrace from $NEXTTRACE_URL"
        rm -f "$tmp"
        exit 1
    fi

    mv "$tmp" "$NEXTTRACE_BIN"
    chmod 0755 "$NEXTTRACE_BIN"
}

download_nexttrace

sh install-speedtest.sh
