# shellcheck shell=bats
# shellcheck disable=SC2034 # Variables consumed by externally-loaded powerline functions.

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	setup_libs "colors"
	load "${BASH_IT?}/themes/powerline-multiline/powerline-multiline.base.bash"
}

function __powerline_noop_prompt() { :; }
function _save-and-reload-history() { :; }

@test "powerline-multiline: prints the missing-newline handler first" {
	COLUMNS=20
	POWERLINE_LEFT_PROMPT=("noop")
	POWERLINE_RIGHT_PROMPT=()
	run __powerline_prompt_command
	local prefix
	prefix="$(printf '%*s\r' "$((COLUMNS - 1))" '')"
	[[ "${output}" == "${prefix}"* ]]
}

@test "powerline-multiline: PS1 carries no cursor-movement prefix" {
	POWERLINE_LEFT_PROMPT=("noop")
	POWERLINE_RIGHT_PROMPT=()
	__powerline_prompt_command > /dev/null
	[[ "${PS1}" != *'\e[B'* && "${PS1}" != *'\e[G'* ]]
}
