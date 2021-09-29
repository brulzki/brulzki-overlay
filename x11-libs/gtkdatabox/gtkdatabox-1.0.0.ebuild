# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gtk+ Widgets for live display of large amounts of fluctuating numerical data"
HOMEPAGE="https://sourceforge.net/projects/gtkdatabox/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples +glade test"
RESTRICT="!test? ( test )"

RDEPEND="x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -e '/SUBDIRS/{s: examples::;}' -i Makefile.am -i Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable glade) \
		--disable-static \
		--enable-libtool-lock
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die

	dodoc AUTHORS ChangeLog README TODO

	if use examples; then
		docinto examples
		dodoc "${S}"/examples/*
	fi
}
