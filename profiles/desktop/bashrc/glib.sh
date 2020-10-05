# dev-libs/glib-2.64.2 removed gio-launch-desktop. It is still needed
# by mate-panel for loading .desktop files from the menu and
# panel. This creates a simple shell script to replace it.
#
# https://bugs.archlinux.org/task/65651
# https://gitlab.gnome.org/GNOME/glib/-/issues/1633
# https://github.com/GNOME/glib/commit/8f7faac10fe71c8d8bd5acefa894c4ffa03a2ad4

if [[ "${EBUILD_PHASE}" == "postinst" ]] ; then
	if [[ ! -x /usr/local/bin/gio-launch-desktop ]]; then
        	cat <<-EOF > /usr/local/bin/gio-launch-desktop
		#!/bin/bash
		export GIO_LAUNCHED_DESKTOP_FILE_PID=\$$
		exec "\$@"
		EOF
		chmod 755 /usr/local/bin/gio-launch-desktop
	fi
fi
