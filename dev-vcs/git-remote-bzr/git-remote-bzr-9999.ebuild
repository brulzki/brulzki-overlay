# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

DESCRIPTION="Transparent bidirectional bridge between Git and Bazaar for Git"
HOMEPAGE="https://github.com/felipec/git-remote-bzr"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/felipec/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/felipec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+doc"

BDEPEND="
	doc? ( app-text/asciidoc )
"
RDEPEND="
	dev-vcs/git
	dev-vcs/bzr
"

src_compile() {
	if use doc; then
		emake doc
	fi
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	if use doc; then
		doman "${S}/doc/git-remote-bzr.1"
	fi
}
