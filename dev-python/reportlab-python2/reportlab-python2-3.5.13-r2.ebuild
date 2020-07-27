# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 ) # Tests crash with pypy

inherit distutils-r1 flag-o-matic

MY_PN=${PN/-python2}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Tools for generating printable PDF documents from any data source"
HOMEPAGE="http://www.reportlab.com/"
SRC_URI="mirror://pypi/${P:0:1}/${MY_PN}/${MY_P}.tar.gz
	http://www.reportlab.com/ftp/fonts/pfbfer-20070710.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="-doc -examples"

RDEPEND="
	dev-python/pillow-python2[tiff,truetype,jpeg(+),${PYTHON_USEDEP}]
	!dev-python/reportlab[${PYTHON_USEDEP}]
	media-libs/libart_lgpl
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip
"

PATCHES=(
	"${FILESDIR}/${MY_PN}-3.5.13-disable-network-tests.patch"
	"${FILESDIR}/${MY_PN}-3.5.13-pillow-VERSION.patch"
)

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd ${MY_P}/src/reportlab/fonts || die
	unpack pfbfer-20070710.zip
}

#python_compile_all() {
#	use doc && emake -C docs html
#}

python_prepare_all() {
	# remove the README to avoid file collisions with python3 package
	rm ${S}/README.txt
	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	fi
	distutils-r1_python_compile
}

python_test() {
	pushd tests > /dev/null || die
	"${PYTHON}" runAll.py || die "Testing failed with ${EPYTHON}"
	popd > /dev/null || die
}

python_install_all() {
	# don't install docs
	#use doc && local HTML_DOCS=( docs/build/html/. )
	#if use examples ; then
	#	docinto examples
	#	dosod -r demos/. tools/pythonpoint/demos
	#fi

	docinto python2_7
	distutils-r1_python_install_all
}