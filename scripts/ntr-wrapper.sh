#!/bin/sh

set -eu

NTR_HOME=${NTR_HOME:-/opt/ntr}

mkdir -p "$NTR_HOME"
cd "$NTR_HOME"
exec /usr/local/bin/nexttrace --dn42 "$@"
