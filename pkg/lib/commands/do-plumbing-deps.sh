# shellcheck shell=bash

# @summary: Globally installs package runtime dependencies.
# It installs the package dependencies, specified with the
# DEPS= variable on package.sh.
# Usage: bpm _deps <package>
# Example: DEPS=username/repo1:otheruser/repo2

bpm-plumbing-deps() {
	local package="$1"
	ensure.nonZero 'package' "$package"

	local -a deps=()
	if [ -f "$BPM_PACKAGES_PATH/$package/package.sh" ]; then
		util.extract_shell_variable "$BPM_PACKAGES_PATH/$package/package.sh" 'DEPS'
		IFS=':' read -ra deps <<< "$REPLY"
	fi

	for dep in "${deps[@]}"; do
		bpm-install "$dep"
	done
}