# Copyright (C) 2013 Emerist, Ltd.
# Distributed under the terms of the Emerist Open Source License v1
# $Header: $

EAPI=2

inherit games

DESCRIPTION="Minecraft is a game about placing blocks while running from skeletons. Or something like that.."
HOMEPAGE="http://www.minecraft.net/"

MY_PN="Minecraft"
URI="https://s3.amazonaws.com/${MY_PN}.Download/launcher/${MY_PN}.jar"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-misc/wget"
RDEPEND="x11-apps/xrandr
	|| ( dev-java/icedtea-bin
		dev-java/icedtea[X]
		dev-java/oracle-jre-bin[X]
		dev-java/sun-jre-bin[X] )"

GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

src_prepare() {
	wget "${URI}" -O "${PN}.jar" || die 
	
	cp "${FILESDIR}/${PN}.png" "${PN}.png" 
}

src_install() {
	insinto "${GAMEDIR}" 

	doins "${PN}.jar" 

	mkdir -p "${D}/${GAMES_BINDIR}" 

	local wrapper="${D}/${GAMES_BINDIR}/${PN}"
	touch "${wrapper}" 

	cat << EOF >> "${wrapper}" 
#!/bin/sh
cd "${GAMEDIR}"
java -Xmx1024M -Xms512M -jar "${PN}.jar"
EOF

	doicon "${FILESDIR}/${PN}.png" 
	make_desktop_entry "${PN}" "${MY_PN}" 

	prepgamesdirs
}
