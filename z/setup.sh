#!/usr/bin/env bash

{ readonly OK=0; readonly ERROR=1; }

{ readonly Z_HOME="${HOME}/bin/z"; 
    readonly Z_REPOSITORY="https://github.com/rupa/z.git"; }

function clone_repository
{
    [[ -d ${Z_HOME} ]] && \
        { pushd ${Z_HOME}; git pull; popd; } >/dev/null || \
        { git clone ${Z_REPOSITORY} ${Z_HOME}; }
    return $?
}

function assign-permissions
{
    chmod +x ${Z_HOME}/z.sh
    return $?
}

function setup-z
{
    clone_repository && \
        assign-permissions
    return $?
}

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
setup-z
popd >/dev/null 2>&1
exit ${OK}

