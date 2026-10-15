# shellcheck shell=bats

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	setup_libs "helpers"
	load "${BASH_IT?}/lib/completion.bash"
	load "${BASH_IT?}/completion/available/sdkman.completion.bash"
}

@test "completion sdkman: install completes candidates from SDKMAN_CANDIDATES_CSV" {
	SDKMAN_CANDIDATES_CSV='java,jbang,kotlin'
	COMP_WORDS=(sdk install j)
	COMP_CWORD=2
	COMPREPLY=()
	_sdkman_complete
	assert_equal "${COMPREPLY[*]}" 'java jbang'
}

@test "completion sdkman: does not leak a global 'line' variable" {
	unset line
	SDKMAN_CANDIDATES_CSV='java'
	COMP_WORDS=(sdk install '')
	COMP_CWORD=2
	_sdkman_complete
	[[ -z "${line+set}" ]]
}
