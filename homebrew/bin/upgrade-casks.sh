#!/usr/bin/env bash
brew update && \
    brew outdated --cask 2>/dev/null | awk '{ print $1 }' | xargs -n 1 brew upgrade --cask && \
    brew cleanup --prune=0
exit $?

