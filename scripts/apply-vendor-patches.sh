#!/bin/sh

set -eu
cd "$(dirname "$0")/.."

for name in proxmox proxmox-backup; do
    [ -d "vendor/$name" ] || continue
    git submodule update --init "vendor/$name"

    for patch in "$PWD"/patches/"$name"/*.patch; do
        [ -e "$patch" ] || continue
        if git -C "vendor/$name" apply --reverse --check "$patch" 2>/dev/null; then
            echo "already applied: $patch"
        else
            echo "applying: $patch"
            git -C "vendor/$name" apply "$patch"
        fi
    done
done
