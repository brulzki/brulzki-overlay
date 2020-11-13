# patch pambase for sssd support

# override src_prepare to apply a patch file from the profile
src_prepare() {
	# locate the last bashrc file present (this file)
	local bashrc="${PORTAGE_BASHRC_FILES##*$'\n'}"
	local patch="${bashrc/pambase.sh/pambase-sssd-${PV}.patch}"
	einfo "patch ${patch}"
	[[ -e ${patch} ]] || die
	PATCHES+=( "${patch}" )
	default
}
