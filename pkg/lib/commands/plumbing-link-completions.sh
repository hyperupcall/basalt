# shellcheck shell=bash

basher-plumbing-link-completions() {
	local package="$1"

	if [ ! -f "$BPM_PACKAGES_PATH/$package/package.sh" ]; then
		return
	fi

	source "$BPM_PACKAGES_PATH/$package/package.sh" # TODO: make this secure?
	IFS=: read -ra bash_completions <<< "$BASH_COMPLETIONS"
	IFS=: read -ra zsh_completions <<< "$ZSH_COMPLETIONS"

	for completion in "${bash_completions[@]}"; do
		mkdir -p "$BPM_PREFIX/completions/bash"
		ln -sf "$BPM_PACKAGES_PATH/$package/$completion" "$BPM_PREFIX/completions/bash/${completion##*/}"
	done

	for completion in "${zsh_completions[@]}"; do
		local target="$BPM_PACKAGES_PATH/$package/$completion"

		if grep -sq "#compdef" "$target"; then
			mkdir -p "$BPM_PREFIX/completions/zsh/compsys"
			ln -sf "$target" "$BPM_PREFIX/completions/zsh/compsys/${completion##*/}"
		else
			mkdir -p "$BPM_PREFIX/completions/zsh/compctl"
			ln -sf "$target" "$BPM_PREFIX/completions/zsh/compctl/${completion##*/}"
		fi
	done
}
