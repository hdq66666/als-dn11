#!/bin/sh

set -eu

NEXTTRACE_HOST=${NEXTTRACE_HOST:-git.baimeow.dn11}
NEXTTRACE_PATH="/hdq66666/ntr/raw/branch/main/nexttrace_linux_amd64"
NEXTTRACE_URL="https://${NEXTTRACE_HOST}${NEXTTRACE_PATH}"
NEXTTRACE_BIN="/usr/local/bin/nexttrace"
NEXTTRACE_IP=${TARGET_IP:-172.16.4.70}

error() {
    printf '%s\n' "$1" >&2
}

ensure_tools() {
    if ! command -v curl >/dev/null 2>&1; then
        apk add --no-cache curl >/dev/null 2>&1
    fi
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

    ensure_tools

    printf 'Download %s to %s\n' "$NEXTTRACE_URL" "$NEXTTRACE_BIN"
    if ! curl -fsSL --retry 3 --retry-delay 1 --insecure --resolve "${NEXTTRACE_HOST}:443:${NEXTTRACE_IP}" -o "$tmp" "$NEXTTRACE_URL"; then
        rm -f "$tmp"
        error "Failed to download nexttrace from $NEXTTRACE_URL"
        exit 1
    fi

    install -m 0755 "$tmp" "$NEXTTRACE_BIN"
    rm -f "$tmp"
}

download_nexttrace

sh install-speedtest.sh
