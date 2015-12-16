# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Precompiled kernel and modules"
HOMEPAGE="http://brulzki.net"
SRC_URI="http://p.brulzki.net/gentoo/packages/kernel/linux-${PV}-gentoo-x86_64-x86.tar.xz"

LICENSE="GPL-2"
SLOT="${PVR}"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

RESTRICT="binchecks mirror strip"

src_prepare() {
	#hide kernel vectors
	#chmod go= boot/System* || die
	# on a filesystem with permissions
	mv boot/System* lib/modules/* || die
	elog "System.map has been moved to $(ls -d lib/modules/*)"

	#BS - delete the uncompressed image
	rm boot/vmlinux*
}

src_install() {
	mv -v boot "${D}" || die

	dodir /lib
	mv -v lib/modules "${D}"/lib || die
}
