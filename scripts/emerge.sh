#!/bin/bash

# emerge wrapper to help with the 17.1 profile migration

. ${0%/*}/e-functions.sh

if [[ "$(realpath ${ROOT%/}/lib)" == "${ROOT%/}/lib64" || \
      "$(realpath ${ROOT%/}/usr/lib)" == "${ROOT%/}/usr/lib64" ]] ; then
    einfo "System has not yet migrated to 17.1 profile"
    eval "$(grep ^PORTAGE_BINHOST /etc/portage/make.conf)"
    debug "PORTAGE_BINHOST = ${PORTAGE_BINHOST}"
    if [[ -v PORTAGE_BINHOST ]]; then
	export PORTAGE_BINHOST="${PORTAGE_BINHOST/\/packages\//\/packages\/17.0\/}"
	einfo "Modifying PORTAGE_BINHOST"
	einfo "PORTAGE_BINHOST = ${PORTAGE_BINHOST}"
    fi
elif [[ -d "${ROOT%/}/lib.new" || -d "${ROOT%/}/usr/lib.new" ]] ; then
    eerror "17.1 profile migration is is progress. Don't emerge!!"
    eerror "Use 'unsymlink-lib --finish' to continue migration"
    eerror "Or 'unsymlink-lib --rollback' to abandon"
    die "ERROR: 17.1 migration is incomplete!!"
else
    # Migration has finished; this is the 17.1 profile
    einfo "System migration is complete"
    if [[ -L "${ROOT%/}/lib32" ]]; then
	einfo "Update @world to complete the 17.1 profile migration"
    fi
fi

/usr/bin/emerge "${@}"
