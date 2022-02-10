# shellcheck shell=bash

eval "$(basalt-package-init)" || exit
basalt.package-init
basalt.package-load
# basalt.load 'github.com/hyperupcall/bats-all' 'load.bash' || exit

load './util/test_util.sh'

export NO_COLOR=

setup() {
	cd "$BATS_TEST_TMPDIR"
}

teardown() {
	cd "$BATS_SUITE_TMPDIR"
}