# Copyright 2019 Bruce Schultz <brulzki@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=7


inherit autotools user

DESCRIPTION="AirPlay audio player with multi-room capability"
HOMEPAGE="https://github.com/mikebrady/shairport-sync"
SRC_URI="https://github.com/mikebrady/shairport-sync/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="+alsa doc pipe pulseaudio soxr stdout systemd test zeroconf"

REQUIRED_USE="|| ( alsa pipe pulseaudio stdout )"

RESTRICT="!test? ( test )"

RDEPEND="dev-libs/openssl
	zeroconf? ( net-dns/avahi )
	soxr? ( media-libs/soxr )
	dev-libs/popt
	alsa? ( media-libs/alsa-lib )
	dev-libs/libconfig
	dev-libs/libdaemon
	pulseaudio? ( media-sound/pulseaudio )"

DEPEND="${RDEPEND}
	doc? ( app-doc/xmltoman )"

BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	# Revert adding users with 'make install'
	eapply -R "${FILESDIR}/useradd.patch"
	autoreconf -if
}

src_configure() {
	#   ./configure --prefix=/usr --sysconfdir=/etc --with-alsa --with-pa --with-avahi --with-ssl=openssl --with-soxr --with-dns_sd --with-pkg-config --with-systemd --with-configfiles
	# --prefix=/usr --sysconfdir=/etc are set by econf
	econf \
		--with-ssl=openssl \
		--with-pkg-config \
		--with-piddir=/run/shairport-sync \
		--without-configfiles \
		$(usex alsa --with-alsa "") \
		$(usex pipe --with-pipe "") \
		$(usex pulseaudio --with-pa "") \
		$(usex zeroconf --with-avahi --with-tinysvcmdns) \
		$(usex systemd --with-systemd "") \
		--with-metadata

	# other options:

	# --with-stdout : include an optional backend module to enable raw
	#     audio to be output through standard output (stdout)

	# --with-pipe : include an optional backend module to enable raw
	#     audio to be output through a unix pipe.

	# --with-soxr : for libsoxr-based resampling.

	# --without-configfiles (configfiles is the default)
	# --with-apple-alac

	# --with-convolution : include a convolution filter that can be used
	#     to apply effects such as frequency and phase correction, and a
	#     loudness filter that compensates for human ear non-linearity.
	#     Requires libsndfile
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.init ${PN}

	insinto /usr/lib/tmpfiles.d
	newins "${FILESDIR}"/${PN}.tmpfiles ${PN}.conf

	#newdoc scripts/shairport-sync.conf shairportsync.conf.example
	dodoc scripts/shairport-sync.conf

	#/lib/systemd/system/shairport-sync.service (but remove avahi if necessary)
	# adduser shairport-sync
	# addgrup shairport-sync [or just use audio??]
}

pkg_postinst() {
	enewuser shairport-sync -1 "" "/var/lib/shairport-sync" audio
}
