#!/usr/bin/env bats

load './util/init.sh'

# The following functions are defined so the names of the function
# at the callsite can be tested. Otherwise, the function names are
# automatically generated by Bats (and are more difficult to test)
errorfn() { "$@"; }
warnfn() { "$@"; }
infofn() { "$@"; }

@test "core.print_error_fn works" {
	run errorfn core.print_error_fn
	assert_success
	assert_output 'Error: errorfn()'

	run errorfn core.print_error_fn 'Something'
	assert_success
	assert_output 'Error: errorfn(): Something'
}

@test "core.print_warn_fn works" {
	run warnfn core.print_warn_fn
	assert_success
	assert_output 'Warn: warnfn()'

	run warnfn core.print_warn_fn 'Something'
	assert_success
	assert_output 'Warn: warnfn(): Something'
}

@test "core.print_info_fn works" {
	run infofn core.print_info_fn
	assert_success
	assert_output 'Info: infofn()'

	run infofn core.print_info_fn 'Something'
	assert_success
	assert_output 'Info: infofn(): Something'
}

@test "core.print_error works" {
	run errorfn core.print_error
	assert_success
	assert_output 'Error: '

	run errorfn core.print_error 'Something'
	assert_success
	assert_output 'Error: Something'
}

@test "core.print_warn works" {
	run warnfn core.print_warn
	assert_success
	assert_output 'Warn: '

	run warnfn core.print_warn 'Something'
	assert_success
	assert_output 'Warn: Something'
}

@test "core.print_info works" {
	run infofn core.print_info
	assert_success
	assert_output 'Info: '

	run infofn core.print_info 'Something'
	assert_success
	assert_output 'Info: Something'
}