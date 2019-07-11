# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A toolkit to build database reports in Python programs"
HOMEPAGE="http://pythonreports.sourceforge.net"

if [[ ${PV} = 9999 ]]; then
	inherit bzr
	EBZR_REPO_URI="bzr://pythonreports.bzr.sourceforge.net/bzrroot/pythonreports"
	KEYWORDS=""
else
	MY_PN="PythonReports"
	MY_P="${MY_PN}-${PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="mirror://sourceforge/${PN}/${MY_PN}/${PV}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="-tcl"

RDEPEND="
	dev-python/reportlab[${PYTHON_USEDEP}]
	dev-python/wxpython[${PYTHON_USEDEP}]
	tcl? ( dev-tcltk/tix )
"
DEPEND="${RDEPEND}"
