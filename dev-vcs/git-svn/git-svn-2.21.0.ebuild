# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
IUSE="doc +iconv +nls +threads test svnfe"

S="${WORKDIR}/${MY_P}"

RDEPEND="
	dev-vcs/git[perl,-subversion]
	dev-vcs/subversion[-dso,perl]
	dev-perl/libwww-perl
	dev-perl/TermReadKey
"

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

	# For svn-fe
	extlibs="-lz -lssl ${S}/xdiff/lib.a $(usex threads -lpthread '')"

	# can't define this to null, since the entire makefile depends on it
	sed -i -e '/\/usr\/local/s/BASIC_/#BASIC_/' Makefile

	use iconv \
		|| myopts+=" NO_ICONV=YesPlease"
	use nls \
		|| myopts+=" NO_GETTEXT=YesPlease"
	myopts+=" NO_SVN_TESTS=YesPlease"

	export MY_MAKEOPTS="${myopts}"
	export EXTLIBS="${extlibs}"
}

src_unpack() {
	if [[ ${PV} != *9999 ]]; then
		unpack ${MY_P}.tar.${SRC_URI_SUFFIX}
		cd "${S}"
		unpack ${PN/-svn}-manpages-${DOC_VER}.tar.${SRC_URI_SUFFIX}
		use doc && \
			cd "${S}"/Documentation && \
			unpack ${PN/-svn}-htmldocs-${DOC_VER}.tar.${SRC_URI_SUFFIX}
		cd "${S}"
	else
		git-r3_src_unpack
		cd "${S}"
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
	# bug #326625: PERL_PATH, PERL_MM_OPT
	# bug #320647: PYTHON_PATH
	PYTHON_PATH=""
	#use python && PYTHON_PATH="${PYTHON}"
	emake ${MY_MAKEOPTS} \
		  DESTDIR="${D}" \
		  OPTCFLAGS="${CFLAGS}" \
		  OPTLDFLAGS="${LDFLAGS}" \
		  OPTCC="$(tc-getCC)" \
		  OPTAR="$(tc-getAR)" \
		  prefix="${EPREFIX}"/usr \
		  htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		  sysconfdir="${EPREFIX}"/etc \
		  PYTHON_PATH="${PYTHON_PATH}" \
		  PERL_MM_OPT="" \
		  GIT_TEST_OPTS="--no-color" \
		  V=1 \
		  "$@"
	# This is the fix for bug #326625, but it also causes breakage, see bug
	# #352693.
	# PERL_PATH="${EPREFIX}/usr/bin/env perl" \
}

src_configure() {
	exportmakeopts
}

src_compile() {
	git_emake SCRIPT_PERL=git-svn.perl build-perl-script || die "emake failed"

	if use svnfe; then
		cd "${S}"/contrib/svn-fe
		# by defining EXTLIBS we override the detection for libintl and
		# libiconv, bug #516168
		local nlsiconv=
		use nls && use !elibc_glibc && nlsiconv+=" -lintl"
		use iconv && use !elibc_glibc && nlsiconv+=" -liconv"
		git_emake EXTLIBS="${EXTLIBS} ${nlsiconv}" || die "emake svn-fe failed"
		if use doc ; then
			git_emake svn-fe.{1,html} || die "emake svn-fe.1 svn-fe.html failed"
		fi
		cd "${S}"
	fi
}

src_install() {
	exeinto /usr/libexec/git-core/
	doexe "${S}"/git-svn
	doman "${S}"/man1/git-svn.1

	if use svnfe; then
		cd "${S}"/contrib/svn-fe
		dobin svn-fe
		dodoc svn-fe.txt
		if use doc ; then
			doman svn-fe.1
			docinto html
			dodoc svn-fe.html
		fi
		cd "${S}"
	fi
}
