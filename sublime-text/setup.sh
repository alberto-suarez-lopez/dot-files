#!/usr/bin/env bash

{ readonly OK=0; readonly ERROR=1; }

readonly OS="$(uname)"

{ readonly ST_HOME="${HOME}/Library/Application Support/Sublime Text 3"; 
    readonly ST_PREFERENCES_DIR="${ST_HOME}/Packages/User"; }

{ readonly BACKUP_HOME="${HOME}/.backup"; 
    readonly BACKUP_DIR="${BACKUP_HOME}/$(date +'%Y-%m-%d')"; }

function check-if-installed
{
    [[ $(mdfind -name 'kMDItemFSName=="Sublime Text.app"' -onlyin /Applications -count) -gt 0 ]] && \
        { return ${OK}; } || \
        { return ${ERROR}; }
}

function create-preferences-directory-if-not-present
{
    [[ -d ${ST_PREFERENCES_DIR} ]] || \
        { mkdir -p ${ST_PREFERENCES_DIR}; return $?; }
    return ${OK}
}

function save-current-settings
{
    [[ -d ${BACKUP_DIR} ]] || { mkdir -p ${BACKUP_DIR}; }
    IFS=$'\n'
    cp ${ST_PREFERENCES_DIR}/* ${BACKUP_DIR}
    return ${OK}
}

function create-symlinks
{
    IFS=$'\n'
    for preferences_file in $(ls -1 etc/);
    do 
        source="${ST_PREFERENCES_DIR}/${preferences_file}";
        backup="${BACKUP_DIR}/${preferences_file}";
        [[ -f ${source} && -f ${backup} ]] && { 
            { diff ${source} ${backup} >/dev/null 2>&1; [[ $? -eq ${OK} ]] && { 
                rm ${source};
            }; };
        };
        ln -f -s ${PWD}/etc/${preferences_file} ${source};
    done
    return ${OK}
}

function setup-sublime-text
{
    [[ "${OS}" == "Darwin" ]] || { return ${OK}; }
    check-if-installed && \
        create-preferences-directory-if-not-present && \
        save-current-settings && \
        create-symlinks
    return $?
}

pushd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1
setup-sublime-text
popd >/dev/null 2>&1
exit ${OK}

