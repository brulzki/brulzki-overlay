# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="PPD description files for Kyocera Mita Printers"
HOMEPAGE="http://www.kyoceramita.com.au/"
#SRC_URI="Linux_PPDs_KSL${PV/\./_}.zip"
SRC_URI="LinuxCUPS1.4.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE_LINGUAS="en fr de it pt es"

IUSE=""
for lingua in $IUSE_LINGUAS; do
	IUSE="${IUSE} linguas_$lingua"
done

RDEPEND="net-print/cups"
DEPEND="app-arch/unzip"

#S="${WORKDIR}/PPD's_KSL_${PV}"
S="${WORKDIR}/LinuxCUPS1.4"

RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please download ${A} from: ${HOMEPAGE} ."
	einfo "Select your model of printer, then drivers for Linux."
}

pkg_setup() {
	local onelingua=no
	for lingua in $IUSE_LINGUAS; do
		if use linguas_$lingua; then
			onelingua=yes
			break;
		fi
	done

	[[ ${onelingua} == no ]] && \
		die "At least one value has to be set in LINGUAS"
}

src_compile() { :; }

src_install() {
	insinto /usr/share/cups/model/KyoceraMita

	inslanguage() {
		if use linguas_$1; then
			doins $2/*.ppd || die "failed to install $2 ppds"
			doins $2/*.PPD || die "failed to install $2 ppds"
		fi
	}

	inslanguage en English
	inslanguage fr French
	inslanguage de German
	inslanguage it Italian
	inslanguage pt Portuguese
	inslanguage es Spanish

	# rename *.PPD -> *.ppd
	for f in ${D}${INSDESTTREE}/*.PPD; do
		mv ${f} ${f%PPD}ppd
	done
#	dohtml ReadMe.htm || die
}
