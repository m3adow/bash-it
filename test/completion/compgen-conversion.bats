# shellcheck shell=bats

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

CONVERTED=(artisan capistrano composer dart gem lerna maven ngrok test_kitchen tmux virtualbox)

function local_setup_file() {
	setup_libs "helpers"
	load "${BASH_IT?}/lib/completion.bash"
}

@test "completion: converted files no longer word-split compgen output" {
	local name
	for name in "${CONVERTED[@]}"; do
		run command grep -nE '^[^#]*COMPREPLY=\( *\$\(' "${BASH_IT?}/completion/available/${name}.completion.bash"
		assert_failure
	done
}

@test "completion: converted files still parse" {
	local name
	for name in "${CONVERTED[@]}"; do
		run bash -n "${BASH_IT?}/completion/available/${name}.completion.bash"
		assert_success
	done
}

@test "completion tmux: _tmux_expand completes a ~user prefix into COMPREPLY" {
	source "${BASH_IT?}/completion/available/tmux.completion.bash"
	local cur='~roo' status=0
	_tmux_expand || status=$?
	assert_equal "${status}" 1
	assert_equal "${#COMPREPLY[@]}" 1
	assert_equal "${COMPREPLY[0]}" '~root'
}
