# Copyright 2019 Bruce Schultz <brulzki@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="A Python wrapper for the RtMidi C++ library written with Cython"
HOMEPAGE="https://chrisarndt.de/projects/python-rtmidi/"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SpotlightKid/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/SpotlightKid/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="alsa jack"

RDEPEND="alsa? ( media-libs/alsa-lib )
		jack? ( virtual/jack )"
DEPEND="${RDEPEND}
		dev-python/cython[${PYTHON_USEDEP}]"

python_configure() {
	mydistutilsargs=( $(usex alsa '' --no-alsa)
					  $(usex jack '' --no-jack) )
}
