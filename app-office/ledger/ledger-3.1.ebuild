# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils python bash-completion-r1

DESCRIPTION="A double-entry accounting system with a command-line reporting interface"
HOMEPAGE="http://ledger-cli.org/"
SRC_URI="http://sunder.vehk.de/p/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="BSD"
#KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug doc gnuplot libedit python static-libs bash-completion"
PYTHON_DEPEND="python? 2"

DEPEND=">=dev-libs/boost-1.35[python?]
	dev-libs/gmp
	dev-libs/mpfr
	doc? (
		sys-apps/texinfo
		dev-texlive/texlive-texinfo
		virtual/latex-base
	)
	libedit? ( dev-libs/libedit )"
RDEPEND="${DEPEND}
	gnuplot? ( sci-visualization/gnuplot )"

# include test/input/drewr.dat as it is referenced by the manual
DOCS=(doc/LICENSE test/input/drewr.dat)

src_prepare() {
	cmake-utils_src_prepare

	# disable autodetection for libedit
	# we will rely on the USE flag instead
	sed -i -e '/check_library_exists(edit readline "" HAVE_EDIT)/d' \
		"${S}/CMakeLists.txt" || die "sed failed"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build debug DEBUG)
		$(cmake-utils_use_build doc DOCS)
		$(cmake-utils_use_build doc WEB_DOCS)
		$(cmake-utils_use_build static-libs LIBRARY)
		$(cmake-utils_use_has libedit EDIT)
		$(cmake-utils_use_use python PYTHON)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_make doc
}

src_install() {
	cmake-utils_src_install

	doman doc/ledger.1

	if use gnuplot; then
		mv contrib/report ledger-report
		dobin ledger-report
	fi

	if use bash-completion; then
		newbashcomp contrib/ledger-completion.bash ledger
	fi

	if use doc; then
		dodoc "${BUILD_DIR}"/doc/ledger3.pdf
		dohtml "${BUILD_DIR}"/doc/ledger3.html
	fi

	rm -rf "${ED}"/usr/share/doc/${PN}
}

pkg_postinst() {
	elog "Emerge app-vim/ledger-syntax for vim integration."
}
