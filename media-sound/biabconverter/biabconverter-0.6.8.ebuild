# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="biabconverter converts band-in-a-box files to MMA and Lilypond"
HOMEPAGE="https://brenzi.ch/builder.php?content=projects_biabconverter&lang=en"
SRC_URI="https://brenzi.ch/data/biabconverter-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-lang/perl
	dev-perl/Switch
"

S="${WORKDIR}"/${PN}-${PV}

PATCHES=( "${FILESDIR}/biabconverter-0.6.8-perl-5.30.patch" )

src_install() {
	exeinto /usr/share/biabconverter
	doexe biabconverter
	dosym ../share/biabconverter/biabconverter /usr/bin/biabconverter

	insinto /usr/share/biabconverter
	doins *.pm

	insinto /usr/share/biabconverter/templates
	doins *.lyt

	dodoc README BUGTRACK
}
