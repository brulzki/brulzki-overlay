# Copyright 2021 Bruce Schultz <brulzki@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )

inherit distutils-r1

DESCRIPTION="JACK Audio Connection Kit (JACK) Client for Python"
HOMEPAGE="https://github.com/spatialaudio/jackclient-python"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/spatialaudio/${PN}"
	KEYWORDS=""
else
	SRC_URI="https://github.com/spatialaudio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

# dev-python/numpy ??
RDEPEND="virtual/jack"
DEPEND="${RDEPEND}
	dev-python/cffi"
