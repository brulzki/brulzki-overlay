# Copyright 1999-2017 Bruce Schultz
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1 udev

DESCRIPTION="Driver to read TEMPer USB HID devices (USB ID 0c45:7401)"
HOMEPAGE="https://github.com/padelt/temper-python"
RESTRICT="mirror"
SRC_URI="https://github.com/padelt/temper-python/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="munin"

DEPEND="dev-python/pyusb"

src_prepare() {
	distutils-r1_src_prepare
	epatch "${FILESDIR}/${P}-python3.patch"
}

src_install() {
	distutils-r1_src_install
	udev_dorules etc/99-tempsensor.rules
	if use munin; then
		exeinto /usr/libexec/munin/plugins
		doexe etc/munin-temperature
	fi
}
