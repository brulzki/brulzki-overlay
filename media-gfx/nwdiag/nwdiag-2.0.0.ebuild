# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Generate network-diagram image from text"
HOMEPAGE="http://blockdiag.com/en/nwdiag/ https://pypi.org/project/nwdiag/ https://guthub.com/blockdiag/nwdiag/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/blockdiag[${PYTHON_USEDEP}]
	>=dev-python/funcparserlib-0.3.6[${PYTHON_USEDEP}]
	>=dev-python/pillow-2.2.1[${PYTHON_USEDEP}]
"
#	dev-python/webcolors[${PYTHON_USEDEP}]
#	$(python_gen_cond_dep 'dev-python/configparser[${PYTHON_USEDEP}]' -2)
#"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/reportlab[${PYTHON_USEDEP}]
		dev-python/docutils[${PYTHON_USEDEP}]
		media-fonts/ja-ipafonts
	)
"

python_test() {
	esetup.py test
}

pkg_postinst() {
	einfo "For additional functionality, install the following optional packages:"
	einfo "    dev-python/reportlab for pdf format"
	einfo "    media-gfx/imagemagick"
	einfo "    wand: https://pypi.org/project/Wand"
	einfo "          Ctypes-based simple MagickWand API binding for Python"
}
