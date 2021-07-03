#!/usr/bin/env bash
# Summary: Upgrades a package
# Usage: basher upgrade <package>

basher-upgrade() {
  util.test_mock

  if [ "$#" -ne 1 ]; then
    basher-help upgrade
    exit 1
  fi

  package="$1"

  if [ -z "$package" ]; then
    basher-help upgrade
    exit 1
  fi

  IFS=/ read -r user name <<< "$package"

  if [ -z "$user" ]; then
    basher-help upgrade
    exit 1
  fi

  if [ -z "$name" ]; then
    basher-help upgrade
    exit 1
  fi

  ensure.cd "$BASHER_PACKAGES_PATH/$package"
  git pull
}