#!/bin/bash
set -euo pipefail

port=${1:-80}

if [ $port -lt 1024 ]; then
    sudo python -m SimpleHTTPServer $port
else
    python -m SimpleHTTPServer $port
fi
