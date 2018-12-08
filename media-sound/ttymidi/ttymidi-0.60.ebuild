# Copyright 2018 Bruce Schultz <brulzki@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="MIDI for your serial devices"
HOMEPAGE="http://www.varal.org/ttymidi/"
SRC_URI="http://www.varal.org/ttymidi/ttymidi.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}"

src_prepare() {
	default_src_prepare
	epatch "${FILESDIR}/Makefile.patch"
}
