#!/bin/bash
brew update && \
    brew cask upgrade && \
    brew cleanup
exit $?

