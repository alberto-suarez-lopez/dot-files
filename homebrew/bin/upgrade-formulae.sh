#!/usr/bin/env bash
brew update && \
    brew upgrade --build-from-source && \
    brew cleanup --prune=0
exit $?

