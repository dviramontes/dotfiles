#!/usr/bin/env bash

# disk space info
diskinfo() {
    diskutil info / | grep -E '(Free|Available)'
}
