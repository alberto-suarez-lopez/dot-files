#!/usr/bin/env bash

{ readonly OK=0; readonly ERROR=1; }

readonly MYSELF=$(basename $0)

readonly VMs_HOME="${HOME}/VMs"

function usage
{
    echo -e "Usage:\n\t${MYSELF} <vm>"; return
}

[[ $# -ge 1 ]] && { readonly VM="$1"; } || { usage; exit ${ERROR}; }
[[ -d ${VMs_HOME} ]] && \
    { pushd ${VMs_HOME} >/dev/null 2>&1; } || \
    { >&2 echo "No '$(basename ${VMs_HOME})' directory found at '$(dirname ${VMs_HOME})'."; exit ${ERROR}; }
[[ -d ${VM} && -r ${VM}/Vagrantfile ]] && \
    { pushd ${VM} >/dev/null 2>&1; } || \
    { >&2 echo "No 'Vagrantfile' found at '${VM}'."; exit ${ERROR}; }
vagrant halt
vagrant destroy
rm -R .vagrant
{ [[ $# -ge 2 ]] && { readonly HOST="$2"; }; }
[[ ! -z ${HOST} && -x ${HOME}/.ssh && -w ${HOME}/.ssh/known_hosts ]] && { 
    cat ${HOME}/.ssh/known_hosts | grep -E -v "^${HOST} " >${HOME}/.ssh/known_hosts.$$; 
    mv ${HOME}/.ssh/known_hosts.$$ ${HOME}/.ssh/known_hosts; 
}
popd >/dev/null 2>&1
popd >/dev/null 2>&1
exit ${OK}

