# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib

DESCRIPTION="Precompiled kernel and modules"
HOMEPAGE="http://brulzki.net"

LICENSE="GPL-2"
SLOT="${PVR}"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

RESTRICT="strip"

DEPEND="=sys-kernel/hardened-sources-${PVR}"

RDEPEND="sys-kernel/linux-firmware"

src_prepare() {
	cp "${FILESDIR}/config-${PVR}" .config
}

src_configure() {
	[[ ${ARCH} == amd64 ]] && ARCH=x86_64
	cd "/usr/src/linux-${PV}-hardened-r2"
	emake O="${S}" olddefconfig
}

src_compile() {
	[[ ${ARCH} == amd64 ]] && ARCH=x86_64
	cd "/usr/src/linux-${PV}-hardened-r2"
	emake O="${S}"
}

src_install() {
	[[ ${ARCH} == amd64 ]] && ARCH=x86_64
	cd "/usr/src/linux-${PV}-hardened-${PR}"
	dodir /boot
	einstall O="${S}" INSTALL_PATH="${D}"/boot
	emake O="${S}" INSTALL_MOD_PATH="${D}" modules_install
	# moving System.map; hides kernel vectors
	einfo "moving System.map out of /boot"
	mv "${D}boot/System.map-"* "${D}/lib/modules/"* || die
	# remove firmware
	einfo "removing firmware"
	rm -rf "${D}/lib/firmware"
	# move the modules into the correct lib dir
	if [[ $(get_libdir) != lib ]]; then
	   einfo "renaming lib to $(get_libdir)"
	   mv "${D}/lib" "${D}/$(get_libdir)"
	fi
}
