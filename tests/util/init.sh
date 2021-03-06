# shellcheck shell=bash

# Source testing dependencies
export BASALT_IS_TESTING='yes'
load './util/test_util.sh'
load './vendor/bats-all/load.bash'
test_util.get_repo_root
REPO_ROOT=$REPLY

# Source Basalt and its dependencies
for f in "$REPO_ROOT"/pkg/vendor/bash-{core,std,term,toml}/pkg/src/**/?*.sh; do
	source "$f"
done; unset -v f
for f in "$REPO_ROOT"/pkg/src/{bin,commands,public,util}/?*.sh; do
	source "$f"
done; unset -v f

# Rather than append '$REPO_ROOT/bin' to the path, create functions with
# the same name. This way, the shell execution context remains the same, which
# allows us to actually mock functions
source "$REPO_ROOT/pkg/src/bin/basalt-package-init.sh"
source "$REPO_ROOT/pkg/src/bin/basalt.sh"
basalt-package-init() { main.basalt-package-init "$@"; }
basalt() { main.basalt "$@"; }

# Testing variables
export XDG_DATA_HOME=
export NO_COLOR= GIT_ASKPASS=
export BASALT_GLOBAL_REPO="$BATS_TEST_TMPDIR/source"
export BASALT_GLOBAL_DATA_DIR="$BATS_TEST_TMPDIR/localshare"

setup() {
	ensure.cd "$BATS_TEST_TMPDIR"
}

teardown() {
	ensure.cd "$BATS_SUITE_TMPDIR"
}
