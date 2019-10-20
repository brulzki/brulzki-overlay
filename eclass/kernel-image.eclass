# Copyright 2017 Bruce Schultz <brulzki@gmail.com>
# Distributed under the terms of the GNU General Public License v2
#
# Author: Bruce Schultz <brulzki@gmail.com>
#
# eclass for building kernel images

inherit multilib

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install

: ${KERNEL_CONFIG:="config-${PV}"}
: ${KERNEL_SOURCES:="sys-kernel/gentoo-sources"}
if [[ ${PR} == r0 ]]; then
	: ${KERNEL_SRCDIR:="/usr/src/linux-${PV}-gentoo"}
else
	: ${KERNEL_SRCDIR:="/usr/src/linux-${PV}-gentoo-${PR}"}
fi

S=${WORKDIR}

RESTRICT="strip"

DEPEND="=${KERNEL_SOURCES}-${PVR}"

RDEPEND="sys-kernel/linux-firmware"

kernel-image_src_prepare() {
	local config="${FILESDIR}/${KERNEL_CONFIG}"
	if [[ -f "${config}-${PV}" ]]; then
		config="${config}-${PV}"
	fi
	einfo "KERNEL_CONFIG=${KERNEL_CONFIG}"
	einfo "Found ${config##*/}"
	cp "${config}" .config || die "Failed to copy kernel config"
}

kernel-image_src_configure() {
	[[ ${ARCH} == amd64 ]] && ARCH=x86_64
	cd "${KERNEL_SRCDIR}"
	emake O="${S}" olddefconfig
}

kernel-image_src_compile() {
	[[ ${ARCH} == amd64 ]] && ARCH=x86_64
	emake
}

kernel-image_src_install() {
	[[ ${ARCH} == amd64 ]] && ARCH=x86_64
	dodir /boot
	einstall INSTALL_PATH="${D}"/boot
	emake INSTALL_MOD_PATH="${D}" modules_install
	# moving System.map; hides kernel vectors
	einfo "moving System.map out of /boot"
	mv "${D}boot/System.map-"* "${D}/lib/modules/"* || die
	# remove firmware
	einfo "removing firmware"
	rm -rf "${D}/lib/firmware"
}
