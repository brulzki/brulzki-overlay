# Copyright 2019 Bruce Schultz <brulzki@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="MIDI Objects for Python"
HOMEPAGE="https://github.com/mido/mido"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mido/${PN}"
	KEYWORDS=""
else
	SRC_URI="https://github.com/mido/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="dev-python/python-rtmidi"
DEPEND="${RDEPEND}"
