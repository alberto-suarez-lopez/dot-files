#!/usr/bin/env bash
brew update && \
    brew outdated 2>/dev/null | awk '{ print $1 }' | xargs -n 1 brew upgrade --build-from-source && \
    brew cleanup --prune=0
exit $?

