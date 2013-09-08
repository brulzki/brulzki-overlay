# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils git

DESCRIPTION="A program to create cross stitch patterns and charts"
HOMEPAGE="http://kxstitch.sourceforge.net"
#SRC_URI=""
EGIT_REPO_URI="git://kxstitch.git.sourceforge.net/gitroot/kxstitch/kxstitch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="kde-base/kdelibs
	media-gfx/imagemagick"
RDEPEND="${DEPEND}"

