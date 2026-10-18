# shellcheck shell=bats

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	setup_libs "helpers"
	load "${BASH_IT?}/lib/completion.bash"
	load "${BASH_IT?}/plugins/available/aws.plugin.bash"
}

@test "plugins aws: awskeys completes subcommands" {
	COMP_WORDS=(awskeys s)
	COMP_CWORD=1
	__awskeys_comp
	assert_equal "${COMPREPLY[*]}" 'show'
}

@test "plugins aws: awskeys show completes profile names" {
	function __awskeys_list() { printf '%s\n' 'Available credentials:' '    dev' '    prod'; }
	COMP_WORDS=(awskeys show p)
	COMP_CWORD=2
	__awskeys_comp
	assert_equal "${COMPREPLY[*]}" 'prod'
}

@test "plugins aws: no Bash 4+ mapfile" {
	run command grep -n 'mapfile' "${BASH_IT?}/plugins/available/aws.plugin.bash"
	assert_failure 1
}
