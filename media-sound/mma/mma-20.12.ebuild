# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
inherit python-single-r1

DESCRIPTION="MMA - Musical MIDI Accompaniment"
SRC_URI="https://www.mellowood.ca/mma/${PN}-bin-${PV}.tar.gz"
HOMEPAGE="https://www.mellowood.ca/mma/"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

S="${WORKDIR}/${PN}-bin-${PV}"

src_configure() {
	:
}

src_install() {
	newbin mma.py mma
	dobin mma-gb mma-libdoc mma-renum mma-splitrec

	insinto /usr/share/mma
	doins -r MMA lib includes egs plugins

	dodoc -r text/* docs/html
	#dohtml -r docs
	#TODO docs/man/ man-gb.1 mma-libdoc.8 mma-renum.1 mma.1
	doman docs/man/*

	# TODO need to update the database afer install with mma -g
	# should exclude the .mmaDB and .mmaDB2 files from installation
}
