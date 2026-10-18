# shellcheck shell=bats

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	setup_libs "helpers"
	load "${BASH_IT?}/lib/completion.bash"
}

@test "lib completion: _bash-it-compgen filters words by prefix" {
	COMPREPLY=()
	_bash-it-compgen -W 'alpha beta bravo' -- b
	assert_equal "${#COMPREPLY[@]}" 2
	assert_equal "${COMPREPLY[*]}" 'beta bravo'
}

@test "lib completion: _bash-it-compgen clears COMPREPLY and succeeds when nothing matches" {
	COMPREPLY=(stale)
	_bash-it-compgen -W 'alpha' -- z
	assert_equal "${#COMPREPLY[@]}" 0
}

@test "lib completion: _bash-it-compgen sees the caller's local variables" {
	local -a COMPREPLY=()
	local my_local_var=1
	_bash-it-compgen -v -- my_local_
	assert_equal "${COMPREPLY[*]}" 'my_local_var'
}

@test "lib completion: helpers do not use Bash 4+ mapfile/readarray" {
	run command grep -nwE 'mapfile|readarray' "${BASH_IT?}/lib/utilities.bash" "${BASH_IT?}/lib/completion.bash"
	assert_failure 1
}
