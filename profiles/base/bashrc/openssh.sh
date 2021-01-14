# restart sshd when upgrading >=8.2_p1

if [[ "${EBUILD_PHASE}" == "postinst" ]] ; then
    for old_ver in ${REPLACING_VERSIONS}; do
        if ver_test "${old_ver}" -lt "8.2_p1"; then
            ewarn "Attempting to restart running sshd service..."
	    if [[ -d /run/systemd/system ]]; then
		systemctl try-restart sshd
	    else
		rc-service --ifstarted sshd restart
	    fi
        fi
    done
    unset old_ver
fi
