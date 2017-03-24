# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit check-reqs cmake-utils elisp-common python-single-r1 git-2

DESCRIPTION="A double-entry accounting system with a command-line reporting interface"
HOMEPAGE="http://ledger-cli.org/"
#SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

EGIT_REPO_URI="git://github.com/ledger/ledger.git"
EGIT_HAS_SUBMODULES=1

LICENSE="BSD"
#KEYWORDS="~amd64 ~x86"
SLOT="0"
#IUSE="debug doc gnuplot libedit python static-libs bash-completion"
IUSE="doc emacs python"

SITEFILE=50${PN}-gentoo-${PV}.el

CHECKREQS_MEMORY=8G

COMMON_DEPEND="
		dev-libs/boost:=[python?]
		dev-libs/gmp:0=
		dev-libs/mpfr:0=
		emacs? ( virtual/emacs )
"
RDEPEND="
		${COMMON_DEPEND}
		python? ( dev-python/cheetah )
"
DEPEND="
		${COMMON_DEPEND}
		dev-libs/utfcpp
		doc? (
				sys-apps/texinfo
				|| (
						>=dev-texlive/texlive-plainextra-2013
						dev-texlive/texlive-texinfo
				)
				dev-texlive/texlive-fontsrecommended
		)
"

# Building with python integration seems to fail without 8G available
# RAM(!)  Since the memory check in check-reqs doesn't count swap, it
# may be unfair to fail the build entirely on the memory test alone.
# Therefore check-reqs_pkg_pretend is deliberately omitted so that we
# ewarn but not eerror.
pkg_pretend() {
	:
}

pkg_setup() {
	if use python; then
		check-reqs_pkg_setup
		python-single-r1_pkg_setup
	fi
}

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
