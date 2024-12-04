#!/bin/bash

shopt -s nullglob
echo "Creating symlinks for user supplied systemd units"

for f in /etc/systemd/user-units/*; do
    echo "$(basename $f) => $f"
    ln -s $f /etc/systemd/system/$(basename $f)
done
