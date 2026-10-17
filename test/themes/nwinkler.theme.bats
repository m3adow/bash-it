# shellcheck shell=bats

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	setup_libs "preexec"
	load "${BASH_IT?}/themes/base.theme.bash"
}

@test "themes nwinkler: defaults HISTORY_AUTOSAVE to 1" {
	unset HISTORY_AUTOSAVE
	load "${BASH_IT?}/themes/nwinkler/nwinkler.theme.bash"
	assert_equal "${HISTORY_AUTOSAVE-}" 1
}

@test "themes nwinkler: keeps a user-set HISTORY_AUTOSAVE=0" {
	HISTORY_AUTOSAVE=0
	load "${BASH_IT?}/themes/nwinkler/nwinkler.theme.bash"
	assert_equal "${HISTORY_AUTOSAVE-}" 0
}
