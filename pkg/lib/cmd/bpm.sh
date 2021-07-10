# shellcheck shell=bash

set -ETeo pipefail
shopt -s nullglob extglob

main() {
	: "${BPM_ROOT:="${XDG_DATA_HOME:-$HOME/.local/share}/bpm"}"
	: "${BPM_PREFIX:="$BPM_ROOT/cellar"}"
	: "${BPM_PACKAGES_PATH:="$BPM_PREFIX/packages"}"
	: "${BPM_INSTALL_BIN:="$BPM_PREFIX/bin"}"
	: "${BPM_INSTALL_MAN:="$BPM_PREFIX/man"}"
	: "${BPM_INSTALL_COMPLETIONS:="$BPM_PREFIX/completions"}"

	for f in "$PROGRAM_LIB_DIR"/{commands,util}/?*.sh; do
		source "$f"
	done

	local is_global='no'

	for arg; do
		case "$arg" in
		--help)
			util.show_help
			exit
			;;
		--version)
			cat <<-EOF
			Version: $PROGRAM_VERSION
			EOF
			exit
			;;
		--global)
			is_global='yes'
			shift
			;;
		*)
			break
			;;
		esac
	done

	if [ "$is_global" = 'no' ]; then
		if ! project_root_directory="$(
			while [[ ! -f "bpm.toml" && "$PWD" != / ]]; do
				cd ..
			done

			if [[ $PWD == / ]]; then
				die "No 'bpm.toml' file found. Please create one to install local packages or pass the '--global' option"
			fi

			printf "%s" "$PWD"
		)"; then
			exit 1
		fi

		BPM_PREFIX="$project_root_directory/bpm_packages"
		BPM_PACKAGES_PATH="$BPM_PREFIX/packages"
		BPM_INSTALL_BIN="$BPM_PREFIX/bin"
		BPM_INSTALL_MAN="$BPM_PREFIX/man"
		BPM_INSTALL_COMPLETIONS="$BPM_PREFIX/completions"
	fi

	case "$1" in
	add)
		shift
		do-add "$@"
		;;
	complete)
		shift
		do-complete "$@"
		;;
	echo)
		shift
		do-echo "$@"
		;;
	init)
		shift
		do-init "$@"
		;;
	link)
		shift
		do-link "$@"
		;;
	list)
		shift
		do-list "$@"
		;;
	outdated)
		shift
		bpm-outdated "$@"
		;;
	package-path)
		shift
		bpm-package-path "$@"
		;;
	remove)
		shift
		do-remove "$@"
		;;
	upgrade)
		shift
		do-upgrade "$@"
		;;
	*)
		if [ -n "$1" ]; then
			log.error "Command '$1' not valid"
		fi
		util.show_help
		;;
	esac
}

main "$@"
