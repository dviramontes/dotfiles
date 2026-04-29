#!/usr/bin/env bash

# disk space info
diskinfo() {
    diskutil info / | grep -E '(Free|Available)'
}

gitcomain() {
    local latest_commit

    git rev-parse --is-inside-work-tree >/dev/null || return 1
    git remote update

    latest_commit="$(git rev-parse origin/main)" || return 1
    printf 'Latest origin/main commit: %s\n' "$latest_commit"

    git checkout "$latest_commit"
}
