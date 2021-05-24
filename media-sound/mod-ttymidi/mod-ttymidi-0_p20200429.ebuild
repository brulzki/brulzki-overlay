# Copyright 2018-2020 Bruce Schultz <brulzki@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="MIDI for your serial devices"
HOMEPAGE="https://github.com/moddevices/mod-ttymidi"
EGIT_REPO_URI="https://github.com/moddevices/${PN}"

if [[ ${PV} == 9999 ]]; then
	KEYWORDS=""
else
	# 0_p20200429
	EGIT_COMMIT="512edcc6aab390bdd3627cea005861211cd29d67"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	!media-sound/ttymidi
	virtual/jack
"
DEPEND="${RDEPEND}"

src_prepare() {
	default_src_prepare
	sed -i 's!/usr/local!/usr!' Makefile
}

src_install() {
	dobin ttymidi
	dolib.so ttymidi.so
	dodoc README
}
