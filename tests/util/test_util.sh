# shellcheck shell=bash

# @description This mocks a command by creating a function for it, which
# prints all the arguments to the command, in addition to the command name
test_util.mock_command() {
	case "$1" in
	_clone)
		basher-plumbing-clone() {
			local use_ssh="$1"
			local site="$2"
			local user="$3"
			local repository="$4"

			git clone "$BASHER_ORIGIN_DIR/$user/$repository" "$BPM_PACKAGES_PATH/$user/$repository"
		}
		;;
	*)
		eval "$1() { echo \"$1 \$*\"; }"
		;;
	esac
}

test_util.resolve_link() {
	if type -p realpath &>/dev/null; then
		realpath "$1"
	else
		readlink -f "$1"
	fi
}
