#!/usr/bin/env bash

{ readonly OK=0; readonly ERROR=1; }

{ readonly NORD_HOME="${HOME}/bin/nord-dircolors"; 
    readonly NORD_DIRCOLORS="${NORD_HOME}/src/dir_colors"; 
    readonly NORD_REPOSITORY="https://github.com/arcticicestudio/nord-dircolors.git"; }

{ readonly BACKUP_HOME="${HOME}/.backup"; 
    readonly BACKUP_DIR="${BACKUP_HOME}/$(date +'%Y-%m-%d')"; 
    readonly DOT_FILES_TO_BACKUP=".dircolors"; }

function clone_repository
{
    [[ -d ${NORD_HOME} ]] && \
        { pushd ${NORD_HOME}; git pull; popd; } >/dev/null || \
        { git clone ${NORD_REPOSITORY} ${NORD_HOME}; }
    return $?
}

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

function create_symlinks
{
    source="${HOME}/.dircolors";
    backup="${BACKUP_DIR}/.dircolors"
    [[ -f ${source} && -f ${backup} ]] && { 
        { diff ${source} ${backup} >/dev/null 2>&1; [[ $? -eq ${OK} ]] && { 
            rm ${HOME}/.dircolors;
        }; };
    }
    ln -f -s ${NORD_DIRCOLORS} ${HOME}/.dircolors;
    return ${OK}
}

function setup-nord-dircolors
{
    clone_repository && \
        save-current-settings && \
        create_symlinks
    return $?
}

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
setup-nord-dircolors
popd >/dev/null 2>&1
exit ${OK}

