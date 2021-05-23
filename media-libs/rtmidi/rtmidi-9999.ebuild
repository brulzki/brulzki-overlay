# Copyright 2019 Bruce Schultz <brulzki@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Realtime MIDI I/O C++ classes"
HOMEPAGE="http://www.music.mcgill.ca/~gary/rtmidi/"
# similar to the MIT License, with the added (non-binding) *feature*
# that modifications be sent to the developer.
LICENSE="RtMidi"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/thestk/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="http://www.music.mcgill.ca/~gary/rtmidi/release/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="0"
IUSE=""

RDEPEND="media-libs/alsa-lib virtual/jack"
DEPEND="${RDEPEND}"
