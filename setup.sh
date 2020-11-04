#!/usr/bin/env bash

{ readonly OK=0; readonly ERROR=1; }

function setup
{
    item="$1"
    [[ -x ${item}/setup.sh ]] && { 
        ${item}/setup.sh; [[ $? -eq ${OK} ]] || { exit ${ERROR}; };
    }
    return ${OK}
}

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
export DOT_FILES_HOME="${PWD}"
for item in $(ls -d */ | tr -s ' ' | sed 's|\(.*\)/|\1|' | grep -E '^(homebrew|macports)$');
do 
    setup ${item};
done
for item in $(ls -d */ | tr -s ' ' | sed 's|\(.*\)/|\1|' | grep -E -v '^(homebrew|macports)$');
do 
    setup ${item};
done
popd >/dev/null 2>&1
exit ${OK}

