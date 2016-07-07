# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils

DESCRIPTION="A program to create cross stitch patterns and charts"
HOMEPAGE="http://kxstitch.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}/${P}"

DEPEND="kde-base/kdelibs
	media-gfx/imagemagick"
RDEPEND="${DEPEND}"
