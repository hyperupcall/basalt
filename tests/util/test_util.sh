# shellcheck shell=bash
# shellcheck disable=SC2164

test_util.get_bpm_root() {
	REPLY=
	if ! REPLY="$(
		while [[ ! -d ".git" && "$PWD" != / ]]; do
			if ! cd ..; then
				printf "%s\n" "Error: Could not cd to BPM directory"
				exit 1
			fi
		done

		if [[ $PWD == / ]]; then
			printf "%s\n" "Error: Could not find root BPM directory"
			exit 1
		fi

		# BPM root is the parent directory of 'source', which holds
		# the Git repository
		if ! cd ..; then
			printf "%s\n" "Error: Could not cd to BPM directory"
			exit 1
		fi
		printf "%s" "$PWD"
	)"; then
		exit 1
	fi
}

# @description This stubs a command by creating a function for it, which
# prints the command name and its arguments
test_util.stub_command() {
	eval "$1() { echo \"$1 \$*\"; }"
}

# @description Fakes a clone. It accepts a directory
test_util.mock_clone() {
	local srcDir="$1"
	local destDir="$2"

	ensure.non_zero 'srcDir' "$srcDir"
	ensure.non_zero 'destDir' "$destDir"

	# Be explicit with the 'file' protocol. The upstream "repository"
	# is just another (non-bare) Git repository
	git clone "file://$BPM_ORIGIN_DIR/$srcDir" "$BPM_PACKAGES_PATH/$destDir"
}

# @description Clones the repository, and performs any linking, etc.
test_util.mock_add() {
		local pkg="$1"
		ensure.non_zero 'pkg' "$pkg"

		if [[ "$pkg" != */* ]]; then
			die "Improper package path. If you are passing in a single directory name, just make it nested within another subdirectory. This is to ensure BPM_PACKAGES_PATH has the correct layout"
		fi

		test_util.mock_clone "$pkg" "github.com/$pkg"
		do-plumbing-add-deps "github.com/$pkg"
		do-plumbing-link-bins "github.com/$pkg"
		do-plumbing-link-completions "github.com/$pkg"
		do-plumbing-link-man "github.com/$pkg"
}

# @description Mocks a 'bpm link'
test_util.mock_link() {
	local dir="$1"
	ensure.non_zero 'dir' "$dir"

	mkdir -p "$BPM_PACKAGES_PATH/local"
	ln -s "$BPM_ORIGIN_DIR/$dir" "$BPM_PACKAGES_PATH/local"

	do-plumbing-add-deps "local/$dir"
	do-plumbing-link-bins "local/$dir"
	do-plumbing-link-completions "local/$dir"
	do-plumbing-link-man "local/$dir"
}

# @description Utility to begin creating a package
test_util.setup_pkg() {
	local pkg="$1"
	ensure.non_zero 'pkg' "$pkg"

	# We create the "upstream" repository with the same relative
	# filepath as 'pkg' so we can use the same variable to
	# cd to it (rather than having to do ${pkg#*/})
	mkdir -p "$BPM_ORIGIN_DIR/$pkg"
	cd "$BPM_ORIGIN_DIR/$pkg"

	git init .
	touch 'README.md'
	git add .
	git commit -m "Initial commit"
	git branch -M master
}

# @description Utility to finish completing a package
test_util.finish_pkg() {
	git add .
	git commit --allow-empty -m "Make changes"
	cd "$BPM_CWD"
}

# @description Utility function to create an empty package
test_util.create_package() {
	local pkg="$1"
	ensure.non_zero 'pkg' "$pkg"

	test_util.setup_pkg "$pkg"; {
		:
	}; test_util.finish_pkg
}
