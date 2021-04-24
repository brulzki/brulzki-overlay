
# Messages for package gui-libs/display-manager-init-1.0-r3:

# The 'xdm' service has been replaced by new 'display-manager'
# service, please switch now:
#
#   rc-update del xdm default
#   rc-update add display-manager default
#
# Remember to run etc-update or dispatch-conf to update the
# config protected service files.

pkg_postinst() {
	if [[ -L ${EROOT}/etc/runlevels/default/xdm ]]; then
		ewarn "Auto-enabling display-manager service"
		rc-update del xdm default
		rc-update add display-manager default
	fi
}
