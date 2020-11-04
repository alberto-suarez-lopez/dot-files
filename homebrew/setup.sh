#!/usr/bin/env bash

{ readonly OK=0; readonly ERROR=1; }

readonly OS="$(uname)"

function install-homebrew
{
    type -p brew >/dev/null 2>&1; [[ $? -eq ${OK} ]] || { files/install-homebrew.sh; return $?; }
    return ${OK}
}

function install-casks
{
    files/install-casks.sh files/casks-to-install
    return $?
}

function install-formulae
{
    files/install-formulae.sh files/formulae-to-install
    return $?
}

function create_symlinks
{
    [[ -d ${HOME}/Scripts ]] || { mkdir -p ${HOME}/Scripts; }
    for script in install-casks install-formulae upgrade-casks upgrade-formulae;
    do 
        ln -f -s ${PWD}/files/${script} ${HOME}/Scripts/${script};
        ln -f -s ${PWD}/files/${script}.sh ${HOME}/Scripts/${script}.sh;
    done
    return ${OK}
}

function setup-homebrew
{
    [[ "${OS}" == "Darwin" ]] || { return ${OK}; }
    install-homebrew && \
        install-casks && \
        install-formulae && \
        create_symlinks
    return $?
}

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
setup-homebrew
popd >/dev/null 2>&1
exit ${OK}

