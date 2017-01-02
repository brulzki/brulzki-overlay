# Copyright 1999-2014 Tiziano Mueller
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit bash-completion-r1 python-single-r1

DESCRIPTION="CD ripper aiming for accuracy over speed."
HOMEPAGE="http://thomas.apestaart.org/morituri/trac/wiki"
SRC_URI="http://thomas.apestaart.org/download/morituri/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alac +cddb +cdio doc +flac test wav wavpack"

RDEPEND="${PYTHON_DEPS}
	media-sound/cdparanoia
	app-cdr/cdrdao
	media-libs/gstreamer
	alac? ( media-plugins/gst-plugins-ffmpeg )
	cddb? ( dev-python/cddb-py[${PYTHON_USEDEP}] )
	cdio? ( dev-python/pycdio )
	flac? ( media-plugins/gst-plugins-flac )
	wav? ( media-libs/gst-plugins-good )
	wavpack? ( media-plugins/gst-plugins-wavpack )
	dev-python/gst-python[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/epydoc[${PYTHON_USEDEP}] )
	test? ( dev-python/pychecker[${PYTHON_USEDEP}] )"

src_prepare() {
	# replace by fixed path to have it properly set by python_doscript
	sed -i \
		-e 's|@PYTHON@|/usr/bin/python|' \
		bin/rip.in || die

	# checks for .git and makes the install fail if not found
	rm morituri/configure/uninstalled.py
}
src_configure() {
	# disable doc building, we do it manually
	export ac_cv_prog_EPYDOC=""
	# disable automatic tests
	export ac_cv_prog_PYCHECKER=""
	default
}

src_compile() {
	default

	if use doc ; then
		cd doc
		epydoc -o reference ../morituri || die "generating docs failed"
	fi
}

src_install() {
	default
	python_doscript bin/rip

	rm -rf "${D}/etc"
	dobashcomp etc/bash_completion.d/rip

	use doc && dohtml -r doc/reference/*
}
