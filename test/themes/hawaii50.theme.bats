# shellcheck shell=bats

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	setup_libs "preexec"
	load "${BASH_IT?}/themes/base.theme.bash"
	load "${BASH_IT?}/themes/hawaii50/hawaii50.theme.bash"
}

function local_setup() {
	function ips() { printf '%s\n' 127.0.0.1 10.0.0.2 192.168.1.3; }
	function curl() { echo 'Current IP Address: 203.0.113.9'; }
}

@test "themes hawaii50: get_ip_info drops loopback and defers the separator to PS1" {
	run get_ip_info
	assert_output '10.0.0.2${IP_SEPARATOR}192.168.1.3, 203.0.113.9'
}

@test "themes hawaii50: renders IP_SEPARATOR literally" {
	if ((BASH_VERSINFO[0] < 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 4))); then
		skip 'needs ${var@P} (Bash 4.4+)'
	fi
	local out
	IP_SEPARATOR='/\w$(echo pwned)'
	out="$(get_ip_info)"
	assert_equal "${out@P}" '10.0.0.2/\w$(echo pwned)192.168.1.3, 203.0.113.9'
}
