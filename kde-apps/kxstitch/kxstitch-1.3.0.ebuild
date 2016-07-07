# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="A program to create cross stitch patterns and charts"
HOMEPAGE="https://projects.kde.org/projects/kdereview/kxstitch
	https://community.kde.org/Incubator/Projects/KXStitch"
SRC_URI="mirror://kde/stable/kxstitch/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}/${P}"

DEPEND="kde-base/kdelibs
	media-gfx/imagemagick"
RDEPEND="${DEPEND}"
