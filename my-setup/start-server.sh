#!/bin/sh
# Run on the laptop that has the keyboard and mouse you want to share.
# Usage: ./start-server.sh [config-file]
CONF="${1:-$(dirname "$0")/two-laptops.conf}"
exec input-leaps --no-daemon --name laptop-a --config "$CONF" --address :24800
