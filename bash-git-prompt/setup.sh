#!/usr/bin/env bash

{ readonly OK=0; readonly ERROR=1; }

{ readonly BGP_HOME="${HOME}/bin/bash-git-prompt"; 
    readonly BGP_REPOSITORY="https://github.com/magicmonty/bash-git-prompt.git"; }

function clone-repository
{
    [[ -d ${BGP_HOME} ]] && \
        { pushd ${BGP_HOME}; git pull; popd; } >/dev/null || \
        { git clone ${BGP_REPOSITORY} ${BGP_HOME}; }
    return $?
}

function setup-bash-git-prompt
{
    clone-repository
    return $?
}

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
setup-bash-git-prompt
popd >/dev/null 2>&1
exit ${OK}

