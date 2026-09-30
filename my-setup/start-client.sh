#!/bin/sh
# Run on the second laptop.
# Usage: ./start-client.sh <server-ip>
if [ -z "$1" ]; then
    echo "usage: $0 <server-ip>" >&2
    exit 1
fi
exec input-leapc --no-daemon --name laptop-b "$1:24800"
