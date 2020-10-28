#!/bin/bash

{ readonly OK=0; readonly ERROR=1; }

readonly MYSELF=$(basename $0)

{ file="${1:--}"; [[ "${file}" == "-" ]] && { 
    file="$(mktemp 2>/dev/null)"; [[ $? -eq 0 ]] || { file="/tmp/${MYSELF}.$$.tmp"; };
    cat >"${file}";
}; }

function usage
{
    echo -e "Usage:\n\t${MYSELF} <file>"; return
}

[[ -r ${file} ]] || { usage; exit ${ERROR}; }
while read port;
do 
    port install ${port};
done < <(cat ${file})
[[ "${1:--}" == "-" ]] && { rm "${file}"; }
exit ${OK}

