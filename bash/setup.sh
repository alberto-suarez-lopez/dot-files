#!/usr/bin/env bash

{ readonly OK=0; readonly ERROR=1; }

{ readonly BACKUP_HOME="${HOME}/.backup"; 
    readonly BACKUP_DIR="${BACKUP_HOME}/$(date +'%Y-%m-%d')"; 
    readonly DOT_FILES_TO_BACKUP=".bash_aliases .bash_profile .bashrc .profile"; }

function save-current-settings
{
    [[ -d ${BACKUP_DIR} ]] || { mkdir -p ${BACKUP_DIR}; }
    for dot_file in ${DOT_FILES_TO_BACKUP};
    do 
        [[ -f ${HOME}/${dot_file} ]] && \
            { cp ${HOME}/${dot_file} ${BACKUP_DIR}; };
    done
    return ${OK}
}

function create-symlinks
{
    for dot_file in $(ls -1 etc/);
    do 
        source="${HOME}/.${dot_file}";
        backup="${BACKUP_DIR}/.${dot_file}";
        [[ -f ${source} && -f ${backup} ]] && { 
            { diff ${source} ${backup} >/dev/null 2>&1; [[ $? -eq ${OK} ]] && { 
                rm ${source};
            }; };
        };
        ln -f -s ${PWD}/etc/${dot_file} ${source};
    done
    return ${OK}
}

function setup-bash
{
    save-current-settings && \
        create-symlinks
    return $?
}

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
setup-bash
popd >/dev/null 2>&1
exit ${OK}

