# shellcheck shell=bats

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	setup_libs "helpers"
	load "${BASH_IT?}/lib/completion.bash"
}

function local_setup() {
	MOCK_BIN="${BATS_TEST_TMPDIR?}/mock-bin"
	mkdir -p "${MOCK_BIN}"
	printf '%s\n' \
		'#!/usr/bin/env bash' \
		'printf "%s\n" "dmidecode: option requires an argument" "Valid string keywords are:" "  bios-vendor" "  bios-version" >&2' \
		'exit 2' > "${MOCK_BIN}/dmidecode"
	chmod +x "${MOCK_BIN}/dmidecode"
	PATH="${MOCK_BIN}:${PATH}"
	complete -r dmidecode 2> /dev/null || true
	load "${BASH_IT?}/completion/available/dmidecode.completion.bash"
}

@test "completion dmidecode: -s yields one candidate per keyword" {
	COMP_WORDS=(dmidecode -s '')
	COMP_CWORD=2
	_dmidecode
	assert_equal "${#COMPREPLY[@]}" 2
	assert_equal "${COMPREPLY[0]}" 'bios-vendor'
	assert_equal "${COMPREPLY[1]}" 'bios-version'
}

@test "completion dmidecode: does not leak OPTS" {
	unset OPTS
	COMP_WORDS=(dmidecode -t '')
	COMP_CWORD=2
	_dmidecode
	[[ -z "${OPTS+set}" ]]
}
