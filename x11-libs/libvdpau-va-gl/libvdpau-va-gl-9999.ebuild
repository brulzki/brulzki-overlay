# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils virtualx pax-utils

DESCRIPTION="VDPAU driver with VA-API/OpenGL backend"
HOMEPAGE="https://github.com/i-rinat/libvdpau-va-gl"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/i-rinat/libvdpau-va-gl.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/i-rinat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-3"
SLOT="0"

RDEPEND="
	dev-libs/glib:2
	media-libs/glu
	virtual/ffmpeg
	virtual/opengl
	x11-libs/libva[X]
	x11-libs/libvdpau
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="${RDEPEND}"

DOCS=(ChangeLog README.md)

src_compile() {
	cmake-utils_src_compile
	if use test; then
		cmake-utils_src_make build-tests
		pax-mark m "${BUILD_DIR}"/tests/test-*
	fi
}

src_test() {
	VIRTUALX_COMMAND=cmake-utils_src_test virtualmake
}
