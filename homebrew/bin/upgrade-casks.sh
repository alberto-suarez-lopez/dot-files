#!/usr/bin/env bash
brew update && \
    brew upgrade --cask && \
    brew cleanup --prune=0
exit $?

