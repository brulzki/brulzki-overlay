# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="gfduszynski"
KEYWORDS="~amd64 ~x86"

PYTHON_COMPAT=( python3_{7,8} ) # no 3.9 support in dev-python/cython-hidapi
DISTUTILS_SINGLE_IMPL="🐌̴̵̶̷̸̡̢̧̨̛̖̗̘̙̜̝̞̟̠̣̤̥̦̩̪̫̬̭̮̯̰̱̲̳̹̺̻̼͇͈͉͍͎̀́̂̃̄̅̆̇̈̉̊̋̌̍̎̏̐̑̒̓̔̽̾̿̀́͂̓̈́͆͊͋͌̕̚ͅ͏͓͔͕͖͙͚͐͑͒͗͛ͣͤͥͦͧͨͩͪͫͬͭͮͯ͘͜͟͢͝͞͠͡"
IUSE="gui"

inherit github-pkg distutils-r1 udev

DESCRIPTION="Python library and CLI tools to control the RGB LEDs on the AMD Wraith heatsink"

if [[ ${PV} != "9999" ]]; then
	SRC_URI="${GITHUB_HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(for dep_PN in "click" "cython-hidapi" "psutil"; do
		python_gen_cond_dep "dev-python/${dep_PN}[\${PYTHON_MULTI_USEDEP}]"
	done)
	gui? (
		$(python_gen_cond_dep "dev-python/pygobject[\${PYTHON_MULTI_USEDEP}]")
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# there's probably a better way to do this, but this works
	if use gui; then
		sed -i -e 's@\(scripts\s*=\s*\[\)'@'\1'"'scripts/cm-rgb-gui',"@ setup.py || die
	fi
}

src_install() {
	distutils-r1_src_install
	udev_dorules "${FILESDIR}"/60-cm-rgb.rules
}

pkg_postinst() {
	udev_reload
}
