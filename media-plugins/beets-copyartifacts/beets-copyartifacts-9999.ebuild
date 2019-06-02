# Copyright 2018-2019 Bruce Schultz
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )
inherit distutils-r1 eutils

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
fi

DESCRIPTION="A plugin for beets that moves non-music files during the import process"
HOMEPAGE="https://github.com/sbarakat/beets-copyartifacts"
if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/sbarakat/${PN}.git"
	EGIT_BOOTSTRAP=""
	KEYWORDS="~amd64"
else
	SRC_URI="https://github.com/MaartenBaert/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

SLOT=0
LICENSE="MIT"

RDEPEND="media-sound/beets[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
		dev-python/setuptools[${PYTHON_USEDEP}]"
