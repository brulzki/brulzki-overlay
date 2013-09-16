# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
PYTHON_USE_WITH="sqlite"

inherit distutils

DESCRIPTION="Recipe Organizer and Shopping List Generator for Gnome"
HOMEPAGE="http://thinkle.github.com/gourmet/"
SRC_URI="https://github.com/thinkle/gourmet/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome-print pdf rtf"

RDEPEND=">=dev-python/pygtk-2.3.93:2
	dev-python/pygobject:2
	>=dev-python/libgnome-python-2
	>=gnome-base/libglade-2
	dev-python/sqlalchemy
	!=dev-python/sqlalchemy-0.6.4
	virtual/python-imaging
	dev-python/gtkspell-python
	dev-python/python-distutils-extra
	dev-db/metakit[python]
	pdf? ( dev-python/reportlab dev-python/python-poppler )
	rtf? ( dev-python/pyrtf )
	gnome-print? ( dev-python/libgnomeprint-python
	               dev-python/python-poppler )"
DEPEND="${RDEPEND}"

# distutils gets a bunch of default docs
DOCS="TESTS FAQ"

src_prepare() {
	      distutils_src_prepare
	      python_convert_shebangs -r --quiet 2 .
	      sed -i 's/Categories=GNOME;Application;Utility;/Categories=GNOME;Utility;/' gourmet.desktop.in
	      sed -i "s:base_dir = '..':base_dir = '/usr/share':" gourmet/settings.py
	      sed -i 's:data_dir = os.path.join(base_dir, "gourmet", "data"):data_dir = os.path.join(base_dir, "gourmet"):' gourmet/settings.py
}

src_install() {
	      distutils_src_install
	      doman gourmet.1
}
