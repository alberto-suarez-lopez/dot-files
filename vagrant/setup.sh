#!/usr/bin/env bash

{ readonly OK=0; readonly ERROR=1; }

readonly OS="$(uname)"

{ readonly VMs_HOME="${HOME}/VMs"; }

function check-if-installed
{
    type -p vagrant >/dev/null 2>&1; [[ $? -eq ${OK} ]] && \
        { return ${OK}; } || \
        { return ${ERROR}; }
}

function create-directory
{
    [[ -d ${VMs_HOME} ]] || \
        { mkdir -p ${VMs_HOME}; return $?; }
    return ${OK}
}

function create_symlinks
{
    [[ -d ${HOME}/Scripts ]] || { mkdir -p ${HOME}/Scripts; }
    for script in destroy-vm halt-vm up-vm;
    do 
        ln -f -s ${PWD}/files/${script} ${HOME}/Scripts/${script};
        ln -f -s ${PWD}/files/${script}.sh ${HOME}/Scripts/${script}.sh;
    done
    return ${OK}
}

function setup-vagrant
{
    [[ "${OS}" == "Darwin" ]] || { return ${OK}; }
    check-if-installed && \
        create-directory && \
        create_symlinks
    return $?
}

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
setup-vagrant
popd >/dev/null 2>&1
exit ${OK}

