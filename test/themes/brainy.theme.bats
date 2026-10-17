# shellcheck shell=bats

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	setup_libs "preexec"
	load "${BASH_IT?}/lib/completion.bash"
	load "${BASH_IT?}/themes/base.theme.bash"
	load "${BASH_IT?}/themes/brainy/brainy.theme.bash"
}

@test "themes brainy/atomic: no word-split compgen output left" {
	run command grep -nE '^[^#]*COMPREPLY=\( *\$\(' "${BASH_IT?}/themes/brainy/brainy.theme.bash" "${BASH_IT?}/themes/atomic/atomic.theme.bash"
	assert_failure
}

@test "themes brainy: completion offers show for a partial action" {
	COMP_WORDS=(brainy s)
	COMP_CWORD=1
	_brainy_completion
	assert_equal "${COMPREPLY[*]}" "show"
}

@test "themes brainy: completion offers segments after show" {
	COMP_WORDS=(brainy show ba)
	COMP_CWORD=2
	_brainy_completion
	assert_equal "${COMPREPLY[*]}" "battery"
}
