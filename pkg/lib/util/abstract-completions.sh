# shellcheck shell=bash

abstract.completions() {
	local action="$1"
	local id="$2"
	ensure.non_zero 'action' "$action"
	ensure.non_zero 'id' "$id"
	ensure.package_exists "$id"

	case "$action" in
	link)
		log.info "Linking completion files for '$id'"
		;;
	unlink)
		log.info "Unlinking completion files for '$id'"
		;;
	esac

	local bpm_toml_file="$BPM_PACKAGES_PATH/$id/bpm.toml"
	local package_sh_file="$BPM_PACKAGES_PATH/$id/package.sh"

	# Get completion directories
	if [ -f "$bpm_toml_file" ]; then
		if util.get_toml_array "$bpm_toml_file" 'completionDirs'; then
			for dir in "${REPLIES[@]}"; do
				for file in "$BPM_PACKAGES_PATH/$id/$dir"/*; do
					local fileName="${file##*/}"

					if [[ $fileName == *.@(sh|bash) ]]; then
						abstract.completions_do_action_bash "$action" "$file"
					elif [[ $fileName == *.zsh ]]; then
						abstract.completions_do_action_zsh "$action" "$file"
					fi
				done
			done
		else
			abstract.completions_search_heuristics "$action" "$id" 'all'
		fi
	elif [ -f "$package_sh_file" ]; then
		local -a bash_completion_files=() zsh_completion_files=()

		if util.extract_shell_variable "$package_sh_file" 'BASH_COMPLETIONS'; then
			IFS=':' read -ra bash_completion_files <<< "$REPLY"

			for file in "${bash_completion_files[@]}"; do
				abstract.completions_do_action_bash "$action" "$BPM_PACKAGES_PATH/$id/$file"
			done
		else
			abstract.completions_search_heuristics "$action" "$id" 'bash'
		fi

		if util.extract_shell_variable "$package_sh_file" 'ZSH_COMPLETIONS'; then
			IFS=':' read -ra zsh_completion_files <<< "$REPLY"

			for file in "${zsh_completion_files[@]}"; do
				abstract.completions_do_action_zsh "$action" "$BPM_PACKAGES_PATH/$id/$file"
			done
		else
			abstract.completions_search_heuristics "$action" "$id" 'zsh'
		fi
	else
		abstract.completions_search_heuristics "$action" "$id" 'all'
	fi
}

abstract.completions_search_heuristics() {
	local action="$1"
	local id="$2"
	local type="$3"

	for completion_dir in completion completions contrib/completion contrib/completions; do
		for file in "$BPM_PACKAGES_PATH/$id/$completion_dir"/*; do
			local fileName="${file##*/}"

			if [[ $fileName == *.@(sh|bash) ]] && [[ $type == all || $type == bash ]]; then
				abstract.completions_do_action_bash "$action" "$file"
			elif [[ $fileName == *.zsh ]] && [[ $type == all || $type == zsh ]]; then
				abstract.completions_do_action_zsh "$action" "$file"
			fi
		done
	done
}

abstract.completions_do_action_bash() {
	local action="$1"
	local file="$2"

	case "$action" in
	link)
		mkdir -p "$BPM_INSTALL_COMPLETIONS/bash"
		ln -sf "$file" "$BPM_INSTALL_COMPLETIONS/bash/${file##*/}"
		;;
	unlink)
		if [ -f "$BPM_INSTALL_COMPLETIONS/bash/${file##*/}" ]; then
			unlink "$BPM_INSTALL_COMPLETIONS/bash/${file##*/}"
		fi
		;;
	esac

}

abstract.completions_do_action_zsh() {
	local action="$1"
	local file="$2"

	if grep -qs "^#compdef" "$file"; then
		case "$action" in
		link)
			mkdir -p "$BPM_INSTALL_COMPLETIONS/zsh/compsys"
			ln -sf "$file" "$BPM_INSTALL_COMPLETIONS/zsh/compsys/${file##*/}"
			;;
		unlink)
			if [ -f "$BPM_INSTALL_COMPLETIONS/zsh/compsys/${file##*/}" ]; then
				unlink "$BPM_INSTALL_COMPLETIONS/zsh/compsys/${file##*/}"
			fi
			;;
		esac
	else
		case "$action" in
		link)
			mkdir -p "$BPM_INSTALL_COMPLETIONS/zsh/compctl"
			ln -sf "$file" "$BPM_INSTALL_COMPLETIONS/zsh/compctl/${file##*/}"
			;;
		unlink)
			if [ -f "$BPM_INSTALL_COMPLETIONS/zsh/compctl/${file##*/}" ]; then
				unlink "$BPM_INSTALL_COMPLETIONS/zsh/compctl/${file##*/}"
			fi
			;;
		esac
	fi
}