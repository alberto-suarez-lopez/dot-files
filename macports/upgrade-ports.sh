#!/bin/bash
port selfupdate && \
    port upgrade outdated && \
    port clean --all installed && \
    [[ -z $(port echo inactive) ]] || { port -f uninstall inactive; }
exit $?

