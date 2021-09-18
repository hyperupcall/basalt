# shellcheck shell=bash

do-global-add() {
	util.init_global

	local -a pkgs=()
	for arg; do case "$arg" in
	-*)
		print_simple.die "Flag '$arg' not recognized"
		;;
	*)
		pkgs+=("$arg")
		;;
	esac done
}
