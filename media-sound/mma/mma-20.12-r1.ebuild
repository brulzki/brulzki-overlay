# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )
inherit python-single-r1

DESCRIPTION="MMA - Musical MIDI Accompaniment"
HOMEPAGE="https://www.mellowood.ca/mma/"
SRC_URI="https://www.mellowood.ca/mma/${PN}-bin-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="extras"

S="${WORKDIR}/${PN}-bin-${PV}"

src_prepare() {
	default
	cp "${FILESDIR}/setup.py" ${S}/
	cp "${FILESDIR}/mma" ${S}/
	# remove the original .mmaDB files, which point to dev directories
	find ${S}/lib -name .mmaDB -exec rm {} +
}

src_install() {
	python_domodule MMA
	python_doscript mma

	insinto /usr/share/mma
	doins -r lib includes egs plugins

	dodoc -r text/* docs/html
	doman docs/man/mma.1

	if use extras; then
		python_doscript mma-gb mma-libdoc mma-renum mma-splitrec
		doman docs/man/mma-*
	fi
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
}
