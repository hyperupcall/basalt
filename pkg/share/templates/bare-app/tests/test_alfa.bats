#!/usr/bin/env bats

load './util/init.sh'

@test "Outputs 'woofers!'" {
	run TEMPLATE_SLUG

	[ "$status" -eq 0 ]
	[ "$output" = "woofers!" ]
}
