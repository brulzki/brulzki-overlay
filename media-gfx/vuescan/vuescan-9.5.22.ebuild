# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5

inherit eutils versionator

MY_PV=${PV%.*}
MY_PV=${MY_PV/./}
DESCRIPTION="A high-quality scanning and digital camera raw image processing software."
HOMEPAGE="http://www.hamrick.com/"
SRC_URI="x86? ( http://www.hamrick.com/files/vuex32${MY_PV}.tgz )
         amd64? ( http://www.hamrick.com/files/vuex64${MY_PV}.tgz )
	http://www.hamrick.com/vuescan/${PN}.pdf"
RESTRICT="primaryuri"

LICENSE="vuescan"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

S="${WORKDIR}/VueScan"

DEPEND=""
RDEPEND=">=x11-libs/gtk+-2.0
	media-gfx/sane-backends
	dev-libs/libusb-compat"

src_install() {
	insinto /opt/vuescan
	doins vuescan.8ba vuescan.ds
	if use doc; then
		doins ${DISTDIR}/${PN}.pdf
	fi

	exeinto /opt/vuescan
	doexe vuescan
	doicon ${FILESDIR}/VueScan.png

	cat > vuescan.desktop <<-EOF
		[Desktop Entry]
		Name=VueScan
		Type=Application
		Comment=VueScan - easy scanning software
		Exec=/opt/vuescan/${PN}
		Icon=/usr/share/pixmaps/VueScan.png
		Categories=Graphics;Scanning;
	EOF
	
	insinto /usr/share/applications/
	doins vuescan.desktop
}

pkg_postinst() {
	einfo "VueScan expects the webbrowser Mozilla installed in your PATH."
	einfo "You have to change this in the 'Prefs' tab or make available"
	einfo "a symlink/script named 'mozilla' starting your favourite browser."
	einfo "Otherwise VueScan will fail to show the HTML documentation."

	einfo "To use scanner with Vuescan under user you need add user into scanner group."
	einfo "Just run under root: gpasswd -a username scanner"
}
