#!/usr/bin/env bash
#
# Usage: basher _deps <package>
# Summary: Globally installs package runtime dependencies
#
# Installs the package dependencies, specified with the
# DEPS= variable on package.sh.
#
# Example: DEPS=username/repo1:otheruser/repo2

basher-_deps() {
  util.test_mock

  if [ "$#" -ne 1 ]; then
    basher-help _deps
    exit 1
  fi

  package="$1"

  if [ ! -e "$BASHER_PACKAGES_PATH/$package/package.sh" ]; then
    exit
  fi

  source "$BASHER_PACKAGES_PATH/$package/package.sh"
  IFS=: read -a deps <<< "$DEPS"

  for dep in "${deps[@]}"; do
    basher-install "$dep"
  done
}
