# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib

DESCRIPTION="Precompiled kernel and modules"
HOMEPAGE="http://brulzki.net"
#SRC_URI="http://p.brulzki.net/gentoo/packages/kernel/linux-${PV}-gentoo-x86_64-x86.tar.xz"

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

RESTRICT="strip"

DEPEND="=sys-kernel/gentoo-sources-${PVR}"

RDEPEND="sys-kernel/linux-firmware"

src_prepare() {
	cp "${FILESDIR}/config-${PV}" .config
}

src_configure() {
	[[ ${ARCH} == amd64 ]] && ARCH=x86_64
	if [[ ${PR} == r0 ]]; then
		cd "/usr/src/linux-${PV}-gentoo"
	else
		cd "/usr/src/linux-${PV}-gentoo-${PR}"
	fi
	emake O="${S}" olddefconfig
}

src_compile() {
	[[ ${ARCH} == amd64 ]] && ARCH=x86_64
	#cd "/usr/src/linux-${PV}-gentoo"
	#emake O="${S}"
	emake
}

src_install() {
	[[ ${ARCH} == amd64 ]] && ARCH=x86_64
	#cd "/usr/src/linux-${PV}-gentoo"
	dodir /boot
	#einstall O="${S}" INSTALL_PATH="${D}"/boot
	#emake O="${S}" INSTALL_MOD_PATH="${D}" modules_install
	einstall INSTALL_PATH="${D}"/boot
	emake INSTALL_MOD_PATH="${D}" modules_install
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
