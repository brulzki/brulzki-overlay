# systemd-tmpfiles replaces opentmpfiles
#
# remove any left over init script links

if [[ "${EBUILD_PHASE}" == "postinst" ]] ; then
    for f in boot/opentmpfiles-setup sysinit/opentmpfiles-dev; do
        [[ -L ${EROOT}/etc/runlevels/${f} ]] &&
            rm ${EROOT}/etc/runlevels/${f}
    done
fi
