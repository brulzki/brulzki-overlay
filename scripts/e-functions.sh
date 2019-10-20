# Copyright (c) 2016-2019 Bruce Schultz <brulzki@gmail.com>
# Distributed under the terms of the GNU General Public License v2

# @AUTHOR:
# Bruce Schultz <brulzki@gmail.com>
# @BLURB: Generic functions for gentoo-like scripts
# @DESCRIPTION:
# Implements generic functions useful for gentoo-like scripts (einfo,
# elog, die, etc)

if [[ ! ${_E_FUNCTIONS} ]]; then

__is_fn() {
    #type -t "${1}" > /dev/null 2>&1
    declare -f "${1}" > /dev/null
}

__is_fn einfo || \
einfo() {
    # display a disposable message to the user
    echo "$@" >&2
}

__is_fn elog || \
elog() {
    # log a informative message for the user
    echo "$@" >&2
}

__is_fn ewarn || \
ewarn() {
    echo "$@" >&2
}

__is_fn eerror || \
eerror() {
    echo "$@" >&2
}

__is_fn die || \
die() {
    [ ${#} -eq 0 ] || eerror "${*}"
    exit 2
}

__is_fn debug || \
debug() {
    [[ -v DEBUG ]] && einfo "$@" >&2
}

# has is copied from portage isolated-functions.sh
# License: GPLv2
__is_fn has || \
has() {
    local needle=$1
    shift

    local x
    for x in "$@"; do
        [ "${x}" = "${needle}" ] && return 0
    done
    return 1
}


_E_FUNCTIONS=1
fi
