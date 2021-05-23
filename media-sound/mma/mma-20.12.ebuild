# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )
inherit python-single-r1

DESCRIPTION="MMA - Musical MIDI Accompaniment"
SRC_URI="https://www.mellowood.ca/mma/${PN}-bin-${PV}.tar.gz"
HOMEPAGE="https://www.mellowood.ca/mma/"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

S="${WORKDIR}/${PN}-bin-${PV}"

src_prepare() {
	default
	# remove the original .mmaDB files, which point to dev directories
	find ${S}/lib -name .mmaDB -exec rm {} +
}

src_install() {
	newbin mma.py mma
	dobin mma-gb mma-libdoc mma-renum mma-splitrec

	insinto /usr/share/mma
	doins -r MMA lib includes egs plugins

	dodoc -r text/* docs/html
	doman docs/man/*
}

pkg_postinst() {
	# create Groove dependency database
	elog "Creating the MMA Groove dependency database."
	${EROOT}/usr/bin/mma -G > /dev/null ||
		ewarn "Error encountered while creating the MMA Groove dependency database."
}

pkg_prerm() {
	# delete the Groove dependency database
	find ${EROOT}/usr/share/mma/lib -name .mmaDB -exec rm {} +
	# delete the __pycache__ directory
	[[ -d ${EROOT}/usr/share/mma/MMA/__pycache__ ]] &&
		rm -rf ${EROOT}/usr/share/mma/MMA/__pycache__
}
