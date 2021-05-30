# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic qmake-utils

DESCRIPTION="Alsa Modular Software Synthesizer"
HOMEPAGE="http://alsamodular.sourceforge.net"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/alsamodular/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/alsamodular/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	media-libs/ladspa-sdk
	media-libs/libclalsadrv
	media-libs/alsa-lib
	virtual/jack
	sci-libs/fftw:3.0=
	!dev-ruby/amrita"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

if [[ ${PV} != 9999 ]]; then
	PATCHES=( "${FILESDIR}"/${PN}-2.1.2-fix-build-system.patch )
fi

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-nsm \
		MOC="$(qt5_get_bindir)/moc" \
		LUPDATE="$(qt5_get_bindir)/lupdate" \
		LRELEASE="$(qt5_get_bindir)/lrelease"
}
