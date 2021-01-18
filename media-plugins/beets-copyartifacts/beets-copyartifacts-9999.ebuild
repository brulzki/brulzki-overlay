# Copyright 2018-2021 Bruce Schultz
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 eutils

DESCRIPTION="A plugin for beets that moves non-music files during the import process"
HOMEPAGE="https://github.com/sbarakat/beets-copyartifacts"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sbarakat/${PN}.git"
	EGIT_BOOTSTRAP=""
	KEYWORDS="~amd64"
else
	SRC_URI="https://github.com/MaartenBaert/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

SLOT=0
LICENSE="MIT"

RDEPEND="
	$(python_gen_cond_dep '
		media-sound/beets[${PYTHON_SINGLE_USEDEP}]
	')"

DEPEND="${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_MULTI_USEDEP}]
	')"
