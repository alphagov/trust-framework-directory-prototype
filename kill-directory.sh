#!/bin/bash
set -e

if [ -f "./tmp/pids/directory.pid" ]; then
  echo "Killing directory"
  kill "$(< ./tmp/pids/directory.pid)" || true
  rm -f ./tmp/pids/directory.pid
fi