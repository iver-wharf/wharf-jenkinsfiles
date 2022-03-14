#!/usr/bin/env bash

set -euo pipefail

/etc/init.d/fcgiwrap start
chmod 777 /var/run/fcgiwrap.socket
