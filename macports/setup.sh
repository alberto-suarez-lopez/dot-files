#!/usr/bin/env bash

{ readonly OK=0; readonly ERROR=1; }

readonly OS="$(uname)"

function check-if-installed
{
    type -p port >/dev/null 2>&1; [[ $? -eq ${OK} ]] && \
        { return ${OK}; } || \
        { return ${ERROR}; }
}

function enable-build-from-source
{
    readonly MACPORTS_CONF="/opt/local/etc/macports/macports.conf"
    [[ -w ${MACPORTS_CONF} ]] || \
        { >&2 echo "Configuration file '${MACPORTS_CONF}' not found."; return ${ERROR}; }
    cp ${MACPORTS_CONF} ${MACPORTS_CONF}.factory-defaults
    { cat ${MACPORTS_CONF} | grep -E '^(#)?buildfromsource' >/dev/null 2>&1; 
        [[ $? -eq ${OK} ]] && \
            { sed -i 's/^\(#\)\?buildfromsource\([[:space:]]\+\)\(ifneeded\|always\|never\)$/buildfromsource\2always/' ${MACPORTS_CONF}; } || \
            { echo -e "buildfromsource     \talways" >>${MACPORTS_CONF}; }; }
    return ${OK}
}

function install-ports
{
    bin/install-ports.sh etc/ports-to-install
    return $?
}

function create-symlinks-for-scripts
{
    [[ -d ${HOME}/Scripts ]] || { mkdir -p ${HOME}/Scripts; }
    for script in install-ports upgrade-ports;
    do 
        ln -f -s ${PWD}/bin/${script} ${HOME}/Scripts/${script};
        ln -f -s ${PWD}/bin/${script}.sh ${HOME}/Scripts/${script}.sh;
    done
    return ${OK}
}

function setup-macports
{
    [[ "${OS}" == "Darwin" ]] || { return ${OK}; }
    check-if-installed && \
        { sudo bash -c "$(declare -f enable-build-from-source); enable-build-from-source"; } && \
        { sudo bash -c "$(declare -f install-ports); install-ports"; } && \
        create-symlinks-for-scripts
    return $?
}

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
setup-macports
popd >/dev/null 2>&1
exit ${OK}

