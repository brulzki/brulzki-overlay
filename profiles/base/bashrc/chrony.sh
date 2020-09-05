# net-misc/chrony-3.5.1-r1 changes the ownership of its directories to
# the ntp user/group

if [[ "${EBUILD_PHASE}" == "postinst" ]] ; then
	if [[ $(stat --format="%U" /var/lib/chrony) != "ntp" ]]; then
		einfo "Updating ntp ownership on /var/{lib,log}/chrony"
		chown -R ntp:ntp /var/{lib,log}/chrony
	fi
fi
