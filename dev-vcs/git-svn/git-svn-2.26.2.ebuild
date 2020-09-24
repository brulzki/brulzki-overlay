# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is a test ebuild to allow git to not need to depend on subversion

inherit toolchain-funcs

MY_PV="${PV/_rc/.rc}"
MY_P="${PN/-svn}-${MY_PV}"

DOC_VER=${MY_PV}

DESCRIPTION="Experimental ebuild to install git-svn outside of the git ebuild"
HOMEPAGE="http://www.git-scm.com/"
if [[ ${PV} != *9999 ]]; then
	SRC_URI_SUFFIX="xz"
	SRC_URI_KORG="mirror://kernel/software/scm/git"
	[[ "${PV/rc}" != "${PV}" ]] && SRC_URI_KORG+='/testing'
	SRC_URI="${SRC_URI_KORG}/${MY_P}.tar.${SRC_URI_SUFFIX}
				${SRC_URI_KORG}/${PN/-svn}-manpages-${DOC_VER}.tar.${SRC_URI_SUFFIX}"
				#doc? (
				#	${SRC_URI_KORG}/${PN/-svn}-htmldocs-${DOC_VER}.tar.${SRC_URI_SUFFIX}
				#)"
			[[ "${PV}" = *_rc* ]] || \
				KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc +iconv +nls +perl +threads test"

S="${WORKDIR}/${MY_P}"

RDEPEND="
	dev-vcs/git[perl,-subversion]
	dev-vcs/subversion[-dso(-),perl]
	dev-perl/libwww-perl
	dev-perl/TermReadKey
"

PATCHES=(
	"${FILESDIR}"/git-2.2.0-svn-fe-linking.patch
)

pkg_setup() {
	if has_version "dev-vcs/subversion[dso]"; then
		ewarn "Per Gentoo bugs #223747, #238586, when subversion is built"
		ewarn "with USE=dso, there may be weird crashes in git-svn. You"
		ewarn "have been warned."
	fi
}

# This is needed because for some obscure reasons future calls to make don't
# pick up these exports if we export them in src_unpack()
exportmakeopts() {
	local myopts

	# broken assumptions, because of broken build system ...
	myopts+=" NO_FINK=YesPlease NO_DARWIN_PORTS=YesPlease"
	myopts+=" INSTALL=install TAR=tar"
	myopts+=" SHELL_PATH=${EPREFIX}/bin/sh"
	myopts+=" SANE_TOOL_PATH="
	myopts+=" OLD_ICONV="
	myopts+=" NO_EXTERNAL_GREP="
	# broken assumptions, because of static build system ...
	myopts=(
		NO_SVN_TESTS=YesPlease
		NO_FINK=YesPlease
		NO_DARWIN_PORTS=YesPlease
		INSTALL=install
		TAR=tar
		SHELL_PATH="${EPREFIX}/bin/sh"
		SANE_TOOL_PATH=
		OLD_ICONV=
		NO_EXTERNAL_GREP=
	)


	# For svn-fe
	extlibs=( -lz -lssl ${S}/xdiff/lib.a $(usex threads -lpthread '') )

	# can't define this to null, since the entire makefile depends on it
	sed -i -e '/\/usr\/local/s/BASIC_/#BASIC_/' Makefile

#	use iconv \
#		|| myopts+=" NO_ICONV=YesPlease"
#	use nls \
#		|| myopts+=" NO_GETTEXT=YesPlease"
#	myopts+=" NO_SVN_TESTS=YesPlease"

	export MY_MAKEOPTS="${myopts[@]}"
	export EXTLIBS="${extlibs[@]}"
}

src_unpack() {
	if [[ ${PV} != *9999 ]]; then
		unpack ${MY_P}.tar.${SRC_URI_SUFFIX}
		cd "${S}" || die
		unpack ${PN/-svn}-manpages-${DOC_VER}.tar.${SRC_URI_SUFFIX}
		if use doc ; then
			pushd "${S}"/Documentation &>/dev/null || die
			unpack ${PN/-svn}-htmldocs-${DOC_VER}.tar.${SRC_URI_SUFFIX}
			popd &>/dev/null || die
		fi
		cd "${S}"
	else
		git-r3_src_unpack
		#cp "${FILESDIR}"/GIT-VERSION-GEN .
	fi

}

src_prepare() {
	default

	sed -i \
		-e 's:^\(CFLAGS[[:space:]]*=\).*$:\1 $(OPTCFLAGS) -Wall:' \
		-e 's:^\(LDFLAGS[[:space:]]*=\).*$:\1 $(OPTLDFLAGS):' \
		-e 's:^\(CC[[:space:]]* =\).*$:\1$(OPTCC):' \
		-e 's:^\(AR[[:space:]]* =\).*$:\1$(OPTAR):' \
		-e "s:\(PYTHON_PATH[[:space:]]\+=[[:space:]]\+\)\(.*\)$:\1${EPREFIX}\2:" \
		-e "s:\(PERL_PATH[[:space:]]\+=[[:space:]]\+\)\(.*\)$:\1${EPREFIX}\2:" \
		Makefile contrib/svn-fe/Makefile || die "sed failed"

	# Fix docbook2texi command
	sed -r -i 's/DOCBOOK2X_TEXI[[:space:]]*=[[:space:]]*docbook2x-texi/DOCBOOK2X_TEXI = docbook2texi.pl/' \
		Documentation/Makefile || die "sed failed"
}

git_emake() {
	# bug #320647: PYTHON_PATH
	#local PYTHON_PATH=""
	#use perforce && PYTHON_PATH="${PYTHON}"
	emake ${MY_MAKEOPTS} \
		  prefix="${EPREFIX}"/usr \
		  htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		  perllibdir="$(use perl && perl_get_raw_vendorlib)" \
		  sysconfdir="${EPREFIX}"/etc \
		  DESTDIR="${D}" \
		  GIT_TEST_OPTS="--no-color" \
		  OPTAR="$(tc-getAR)" \
		  OPTCC="$(tc-getCC)" \
		  OPTCFLAGS="${CFLAGS}" \
		  OPTLDFLAGS="${LDFLAGS}" \
		  PERL_PATH="${EPREFIX}/usr/bin/perl" \
		  PERL_MM_OPT="" \
		  PYTHON_PATH="${PYTHON_PATH}" \
		  V=1 \
		  "$@"
}

src_configure() {
	exportmakeopts
}

src_compile() {
	git_emake SCRIPT_PERL=git-svn.perl build-perl-script || die "emake failed"

	# if use subversion; then
	pushd contrib/svn-fe &>/dev/null || die
	# by defining EXTLIBS we override the detection for libintl and
	# libiconv, bug #516168
	local nlsiconv=()
	use nls && use !elibc_glibc && nlsiconv+=( -lintl )
	use iconv && use !elibc_glibc && nlsiconv+=( -liconv )
	git_emake EXTLIBS="${EXTLIBS} ${nlsiconv[@]}" \
		|| die "emake svn-fe failed"
	if use doc ; then
		# svn-fe.1 requires the full USE=doc dependency stack
		git_emake svn-fe.1 \
			|| die "emake svn-fe.1 failed"
		git_emake svn-fe.html \
			|| die "emake svn-fe.html failed"
	fi
	popd &>/dev/null || die
	# fi
}

src_install() {
	exeinto /usr/libexec/git-core/
	doexe "${S}"/git-svn
	doman "${S}"/man1/git-svn.1

	# if use subversion; then
	pushd contrib/svn-fe &>/dev/null || die
	dobin svn-fe
	dodoc svn-fe.txt
	if use doc ; then
		doman svn-fe.1
		docinto html
		dodoc svn-fe.html
	fi
	popd &>/dev/null || die
}
