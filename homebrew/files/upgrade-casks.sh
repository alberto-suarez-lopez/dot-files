#!/usr/bin/env bash
brew update && \
    brew upgrade --cask && \
    brew cleanup
exit $?

