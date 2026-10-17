# shellcheck shell=bats

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	setup_libs "helpers"
}

@test "plugins pack: registers completion for pack" {
	complete -r pack 2> /dev/null || true
	load "${BASH_IT?}/plugins/available/pack.plugin.bash"
	run complete -p pack
	assert_success
	assert_output --partial '__start_pack'
}

@test "plugins pack: loading is not gated on the Bash major version" {
	run command grep -n 'BASH_VERSINFO\[0\]}" -lt 4' "${BASH_IT?}/plugins/available/pack.plugin.bash"
	assert_failure 1
}
