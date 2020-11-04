#!/usr/bin/env bash
brew update && \
    brew cask upgrade && \
    brew cleanup
exit $?

