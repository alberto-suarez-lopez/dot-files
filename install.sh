#!/bin/bash

{ readonly OK=0; readonly ERROR=1; }

readonly OS="$(uname)"

function setup-macports
{
    [[ "${OS}" == "Darwin" ]] || { return ${OK}; }
    readonly MACPORTS_CONF="/opt/local/etc/macports/macports.conf"
    [[ -w ${MACPORTS_CONF} ]] || \
        { >&2 echo "Configuration file '${MACPORTS_CONF}' not found."; return ${ERROR}; }
    cp ${MACPORTS_CONF} ${MACPORTS_CONF}.factory-defaults
    { cat ${MACPORTS_CONF} | grep -E '^(#)?buildfromsource' >/dev/null 2>&1;
        [[ $? -eq ${OK} ]] && \
            { sed -i 's/^\(#\)\?buildfromsource\([[:space:]]\+\)\(ifneeded\|always\|never\)$/buildfromsource\2always/' ${MACPORTS_CONF}; } || \
            { echo -e "buildfromsource     \talways" >>${MACPORTS_CONF}; }; }
    macports/install-ports.sh macports/ports-to-install
    return $?
}

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
{ sudo bash -c "export OS="${OS}"; $(declare -f setup-macports); setup-macports"; 
    [[ $? -eq ${OK} ]] || { exit ${ERROR}; }; } # setup-macports
popd >/dev/null 2>&1
exit ${OK}

