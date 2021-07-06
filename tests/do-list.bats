#!/usr/bin/env bats

load 'util/init.sh'

@test "list installed packages" {
	test_util.mock_command _clone
	create_package username/p1
	create_package username2/p2
	create_package username2/p3
	bpm-install username/p1
	bpm-install username2/p2

	run bpm-list
	assert_success
	assert_line "username/p1"
	assert_line "username2/p2"
	refute_line "username2/p3"
}

@test "displays nothing if there are no packages" {
	run bpm-list --outdated
	assert_success
	assert_output ""
}

@test "displays outdated packages" {
	test_util.mock_command _clone
	create_package username/outdated
	create_package username/uptodate
	bpm-install username/outdated
	bpm-install username/uptodate
	create_exec username/outdated "second"

	run bpm-list --outdated
	assert_success
	assert_output username/outdated
}