
# Migration to amd64/17.1 profile
#
# Detect the state of the profile migration and force the config with
# appropriate options for the lib symlinks.

if [[ "${ARCH}" == "amd64" && "${EBUILD_PHASE}" == "setup" ]] ; then
	if [[ "$(realpath ${ROOT%/}/lib)" == "${ROOT%/}/lib64" || \
		  "$(realpath ${ROOT%/}/usr/lib)" == "${ROOT%/}/usr/lib64" ]] ; then
		einfo "System has not yet migrated to 17.1 profile"
		export LIBDIR_x86="lib32"
		export SYMLINK_LIB="yes"
	elif [[ -d "${ROOT%/}/lib.new" || -d "${ROOT%/}/usr/lib.new" ]] ; then
		eerror "17.1 profile migration is is progress. Don't emerge!!"
		eerror "Use 'unsymlink-lib --finish' to continue migration"
		eerror "Or 'unsymlink-lib --rollback' to abandon"
		die "ERROR: 17.1 migration is incomplete!!"
	elif [[ -d "${ROOT%/}/lib" && ! -L "${ROOT%/}/lib" ]]; then
		# Migration has finished; this is the 17.1 profile
		#einfo "System migration is complete"
		#export LIBDIR_x86="lib"
		#export SYMLINK_LIB="no"
		if [[ -L "${ROOT%/}/lib32" || -L "${ROOT%/}/usr/lib32" ]]; then
			elog "System migration to 17.1 profile is complete, but one of the"
			elog "/lib32 or /usr/lib32 symlinks still remains."
			elog
			elog "Update @world to complete the migration, or remove the links"
			elog "manually if this message persists."
		fi
	fi
fi
