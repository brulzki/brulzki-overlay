# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit kernel-image

DESCRIPTION="Precompiled kernel and modules"
HOMEPAGE="http://brulzki.net"
#SRC_URI="http://p.brulzki.net/gentoo/packages/kernel/linux-${PV}-gentoo-x86_64-x86.tar.xz"

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""
