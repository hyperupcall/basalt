#!/usr/bin/env bats

load 'util/init.sh'

@test "without arguments, prints usage" {
  skip

  run basher-_deps

  assert_failure
  assert_line "Usage: basher _deps <package>"
}

@test "without dependencies, does nothing" {
  mock.command _clone
  mock.command basher-install
  create_package "user/main"
  basher-_clone false site user/main

  run basher-_deps user/main

  assert_success ""
}

@test "installs dependencies" {
  mock.command _clone
  mock.command basher-install
  create_package "user/main"
  create_dep "user/main" "user/dep1"
  create_dep "user/main" "user/dep2"
  basher-_clone false site user/main

  run basher-_deps user/main

  assert_success
  assert_line "basher-install user/dep1"
  assert_line "basher-install user/dep2"
}
