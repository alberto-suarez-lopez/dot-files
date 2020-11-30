#!/usr/bin/env bash

{ readonly OK=0; readonly ERROR=1; }

readonly OS="$(uname)"

function check-if-installed
{
    [[ $(mdfind -name 'kMDItemFSName=="iTerm.app"' -onlyin /Applications -count) -gt 0 ]] && \
        { return ${OK}; } || \
        { return ${ERROR}; }
}

function specify-preferences-directory
{
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${PWD}/etc" && \
        defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
    return $?
}

function setup-iterm2
{
    [[ "${OS}" == "Darwin" ]] || { return ${OK}; }
    check-if-installed && \
        specify-preferences-directory
    return $?
}

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
setup-iterm2
popd >/dev/null 2>&1
exit ${OK}

