# shellcheck shell=bash

basalt-run() {
	util.init_local

	if (($# == 0)); then
		print.die 'The name of an executable must be passed'
	fi

	local bin_name="$0"
	if ! shift; then
		core.panic 'Failed to shift'
	fi

	# Look in current package
	if bash_toml.quick_array_get "$BASALT_LOCAL_PROJECT_DIR/basalt.toml" 'run.binDirs'; then
		for bin_dir in "${REPLY[@]}"; do
			for bin_file in "$BASALT_LOCAL_PROJECT_DIR/$bin_dir"/*; do
				if [ -f "$bin_file" ] && [ -x "$bin_file" ]; then
					util.init_deinit
					print.info "Running $bin_file"
					exec "$bin_file" "$@"
				elif [ -f "$bin_file" ]; then
					print.die "File '$bin_name' is found, but the package providing it has not made it executable"
				else
					print.die "No executable called '$bin_name' was found"
				fi
			done; unset bin_file
		done; unset bin_dir
	fi

	# Look in subdependencies
	local bin_file="$BASALT_LOCAL_PROJECT_DIR/.basalt/bin/$bin_name"
	if [ -f "$bin_file" ] && [ -x "$bin_file" ]; then
		util.init_deinit
		print.info "Running $bin_file"
		exec "$bin_file" "$@"
	elif [ -f "$bin_file" ]; then
		print.die "File '$bin_name' is found, but the package providing it has not made it executable"
	else
		print.die "No executable called '$bin_name' was found"
	fi
}
