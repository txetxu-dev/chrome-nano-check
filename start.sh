#!/usr/bin/env bash
set -eu
cd "$(dirname "$0")"
port="${PORT:-8796}"
printf 'Sirviendo Chrome Nano Check en http://127.0.0.1:%s/\n' "$port"
printf 'Pulsa Ctrl+C para detener el servidor.\n'
exec python3 -m http.server "$port" --bind 127.0.0.1
