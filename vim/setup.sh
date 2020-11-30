#!/usr/bin/env bash

{ readonly OK=0; readonly ERROR=1; }

readonly OS="$(uname)"

{ readonly VIM_HOME="${HOME}/.vim"; }

{ readonly BACKUP_HOME="${HOME}/.backup"; 
    readonly BACKUP_DIR="${BACKUP_HOME}/$(date +'%Y-%m-%d')"; 
    readonly DOT_FILES_TO_BACKUP=".vimrc"; }

function check-if-installed
{
    type -p vim >/dev/null 2>&1; [[ $? -eq ${OK} ]] && \
        { return ${OK}; } || \
        { return ${ERROR}; }
}

function create-vim-directory-if-not-present
{
    [[ -d ${VIM_HOME} ]] || \
        { mkdir -p ${VIM_HOME}; return $?; }
    return ${OK}
}

function install-vim-plug
{
    curl -fLo ${VIM_HOME}/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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

function setup-vim
{
    check-if-installed && \
        create-vim-directory-if-not-present && \
        install-vim-plug && \
        save-current-settings && \
        create-symlinks
    return $?
}

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
setup-vim
popd >/dev/null 2>&1
exit ${OK}

