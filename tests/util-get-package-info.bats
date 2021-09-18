#!/usr/bin/env bats

load './util/init.sh'

@test "fails on no arguments" {
	run util.get_package_info

	assert_failure
	assert_line -p "Must supply a repository"
}

@test "parses with full https url" {
	util.get_package_info 'https://gitlab.com/hyperupcall/proj'

	assert [ "$REPLY1" = 'remote' ]
	assert [ "$REPLY2" = 'https://gitlab.com/hyperupcall/proj.git' ]
	assert [ "$REPLY3" = 'gitlab.com' ]
	assert [ "$REPLY4" = 'hyperupcall/proj' ]
	assert [ "$REPLY5" = '' ]
}

@test "parses with full http url" {
	util.get_package_info 'http://gitlab.com/hyperupcall/proj'

	assert [ "$REPLY1" = 'remote' ]
	assert [ "$REPLY2" = 'http://gitlab.com/hyperupcall/proj.git' ]
	assert [ "$REPLY3" = 'gitlab.com' ]
	assert [ "$REPLY4" = 'hyperupcall/proj' ]
	assert [ "$REPLY5" = '' ]
}

@test "parses with full https url with .git ending" {
	util.get_package_info 'https://gitlab.com/hyperupcall/proj'

	assert [ "$REPLY1" = 'remote' ]
	assert [ "$REPLY2" = 'https://gitlab.com/hyperupcall/proj.git' ]
	assert [ "$REPLY3" = 'gitlab.com' ]
	assert [ "$REPLY4" = 'hyperupcall/proj' ]
	assert [ "$REPLY5" = '' ]
}

@test "parses with full http url with .git ending" {
	util.get_package_info 'http://gitlab.com/hyperupcall/proj.git'

	assert [ "$REPLY1" = 'remote' ]
	assert [ "$REPLY2" = 'http://gitlab.com/hyperupcall/proj.git' ]
	assert [ "$REPLY3" = 'gitlab.com' ]
	assert [ "$REPLY4" = 'hyperupcall/proj' ]
	assert [ "$REPLY5" = '' ]
}

@test "parses with full ssh url" {
	util.get_package_info 'git@gitlab.com:hyperupcall/proj'

	assert [ "$REPLY1" = 'remote' ]
	assert [ "$REPLY2" = 'git@gitlab.com:hyperupcall/proj' ]
	assert [ "$REPLY3" = 'gitlab.com' ]
	assert [ "$REPLY4" = 'hyperupcall/proj' ]
	assert [ "$REPLY5" = '' ]
}

@test "parses with full ssh url with .git ending" {
	util.get_package_info 'git@gitlab.com:hyperupcall/proj.git'

	assert [ "$REPLY1" = 'remote' ]
	assert [ "$REPLY2" = 'git@gitlab.com:hyperupcall/proj' ]
	assert [ "$REPLY3" = 'gitlab.com' ]
	assert [ "$REPLY4" = 'hyperupcall/proj' ]
	assert [ "$REPLY5" = '' ]
}

@test "parses with package and domain" {
	util.get_package_info 'gitlab.com/hyperupcall/proj'

	assert [ "$REPLY1" = 'remote' ]
	assert [ "$REPLY2" = 'https://gitlab.com/hyperupcall/proj.git' ]
	assert [ "$REPLY3" = 'gitlab.com' ]
	assert [ "$REPLY4" = 'hyperupcall/proj' ]
	assert [ "$REPLY5" = '' ]
}

@test "parses with package and domain and ref" {
	util.get_package_info 'gitlab.com/hyperupcall/proj@v0.1.0'

	assert [ "$REPLY1" = 'remote' ]
	assert [ "$REPLY2" = 'https://gitlab.com/hyperupcall/proj.git' ]
	assert [ "$REPLY3" = 'gitlab.com' ]
	assert [ "$REPLY4" = 'hyperupcall/proj' ]
	assert [ "$REPLY5" = 'v0.1.0' ]
}

@test "parses with package" {
	util.get_package_info 'hyperupcall/proj'

	assert [ "$REPLY1" = 'remote' ]
	assert [ "$REPLY2" = 'https://github.com/hyperupcall/proj.git' ]
	assert [ "$REPLY3" = 'github.com' ]
	assert [ "$REPLY4" = 'hyperupcall/proj' ]
	assert [ "$REPLY5" = '' ]
}

@test "parses with package and ref" {
	util.get_package_info 'hyperupcall/proj@v0.2.0'

	assert [ "$REPLY1" = 'remote' ]
	assert [ "$REPLY2" = 'https://github.com/hyperupcall/proj.git' ]
	assert [ "$REPLY3" = 'github.com' ]
	assert [ "$REPLY4" = 'hyperupcall/proj' ]
	assert [ "$REPLY5" = 'v0.2.0' ]
}

@test "parses with file:// protocol" {
	util.get_package_info 'file:///home/directory' 'no'

	assert [ "$REPLY1" = 'local' ]
	assert [ "$REPLY2" = 'file:///home/directory' ]
	assert [ "$REPLY3" = '' ]
	assert [ "$REPLY4" = 'directory' ]
	assert [ "$REPLY5" = '' ]
}

@test "parses with file:// protocol and ref" {
	util.get_package_info 'file:///home/user/directory@v0.2.0' 'no'

	assert [ "$REPLY1" = 'local' ]
	assert [ "$REPLY2" = 'file:///home/user/directory' ]
	assert [ "$REPLY3" = '' ]
	assert [ "$REPLY4" = 'directory' ]
	assert [ "$REPLY5" = 'v0.2.0' ]
}

@test "errors with friendly message if format is not proper" {
	run util.get_package_info 'UwU'

	assert_failure
	assert_line -p "Package 'UwU' does not appear to be formatted correctly"
}
