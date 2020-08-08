# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KERNEL_SOURCES="sys-kernel/rt-sources"
KERNEL_SRCDIR="/usr/src/linux-${PV/_p/-rt}"

inherit kernel-image

DESCRIPTION="Precompiled kernel and modules"
HOMEPAGE="http://brulzki.net"

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""
