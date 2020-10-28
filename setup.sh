#!/bin/bash

{ readonly OK=0; readonly ERROR=1; }

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
export DOT_FILES_HOME="${PWD}"
for item in $(ls -d */ | tr -s ' ' | sed 's|\(.*\)/|\1|');
do 
    [[ -x ${item}/setup.sh ]] && { ${item}/setup.sh; };
done
popd >/dev/null 2>&1
exit ${OK}

