#!/sbin/runscript
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

extra_started_commands="console"

MULTIVERSE="${SVCNAME#*.}"
[[ "${SVCNAME}" == "${MULTIVERSE}" ]] && MULTIVERSE="main"

LOG="/var/lib/minecraft/${MULTIVERSE}/logs/latest.log"
PID="/var/run/minecraft/${MULTIVERSE}.pid"
SOCKET="/tmp/tmux-minecraft-${MULTIVERSE}"

depend() {
	need net
}

start() {
	local SERVER="${SVCNAME%%.*}"
	local EXE="/usr/games/bin/${SERVER}"

	ebegin "Starting Minecraft multiverse \"${MULTIVERSE}\" using ${SERVER}"

	if [[ ! -x "${EXE}" ]]; then
		eend 1 "${SERVER} was not found. Did you install it?"
		return 1
	fi

	if fuser -s "${LOG}" &> /dev/null; then
		eend 1 "This multiverse appears to be in use, maybe by another server?"
		return 1
	fi

	# We can't get the final PID of tmux or the exit status of a
	# program run within it so we use the PID of the server itself and
	# check for success with ewaitfile.
	local CMD="/sbin/start-stop-daemon -S -p '${PID}' -m -k 027 -x ${EXE} -- '${MULTIVERSE}'"
	su -c "/usr/bin/tmux -S '${SOCKET}' new-session -n 'minecraft-${MULTIVERSE}' -d \"${CMD}\"" "@GAMES_USER_DED@"
	ewaitfile 10 "${PID}"

	eend $?
}

stop() {
	ebegin "Stopping Minecraft multiverse \"${MULTIVERSE}\""

	# tmux will automatically terminate when the server does.
	start-stop-daemon -K -p "${PID}"
	rm -f "${SOCKET}"

	eend $?
}

console() {
	exec /usr/bin/tmux -S "${SOCKET}" attach-session
}
