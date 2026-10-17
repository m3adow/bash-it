# shellcheck shell=bats

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	# Copy the test fixture to the Bash-it folder
	cp -fRP "${BASH_IT?}/test/fixtures/bash_it"/* "${BASH_IT?}/" || true
	# don't load any libraries as the tests here test the *whole* kit
}

@test "bash-it: verify that the test fixture is available" {
	assert_file_exist "${BASH_IT?}/aliases/available/a.aliases.bash"
	assert_file_exist "${BASH_IT?}/aliases/available/b.aliases.bash"
}

@test "bash-it: load aliases in order" {
	run ln -s "${BASH_IT?}/plugins/available/base.plugin.bash" "${BASH_IT?}/enabled/250---base.plugin.bash"
	assert_link_exist "${BASH_IT?}/enabled/250---base.plugin.bash"

	run ln -s "${BASH_IT?}/aliases/available/a.aliases.bash" "${BASH_IT?}/enabled/150---a.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/150---a.aliases.bash"
	run ln -s "${BASH_IT?}/aliases/available/b.aliases.bash" "${BASH_IT?}/enabled/150---b.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/150---b.aliases.bash"

	# The `test_alias` alias should not exist
	run alias test_alias &> /dev/null
	assert_failure

	run ln -s "$BASH_IT/aliases/available/a.aliases.bash" "$BASH_IT/enabled/750---a.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/750---a.aliases.bash"
	run ln -s "$BASH_IT/aliases/available/b.aliases.bash" "$BASH_IT/enabled/750---b.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/750---b.aliases.bash"

	load "${BASH_IT?}/bash_it.sh"

	run alias test_alias &> /dev/null
	assert_success
	assert_line -n 0 "alias test_alias='b'"
}

@test "bash-it: load aliases in priority order" {
	run ln -s "${BASH_IT?}/plugins/available/base.plugin.bash" "${BASH_IT?}/enabled/250---base.plugin.bash"
	assert_link_exist "${BASH_IT?}/enabled/250---base.plugin.bash"

	run ln -s "${BASH_IT?}/aliases/available/a.aliases.bash" "${BASH_IT?}/enabled/175---a.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/175---a.aliases.bash"
	run ln -s "${BASH_IT?}/aliases/available/b.aliases.bash" "${BASH_IT?}/enabled/150---b.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/150---b.aliases.bash"

	# The `test_alias` alias should not exist
	run alias test_alias &> /dev/null
	assert_failure

	run ln -s "$BASH_IT/aliases/available/a.aliases.bash" "$BASH_IT/enabled/755---a.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/755---a.aliases.bash"
	run ln -s "$BASH_IT/aliases/available/b.aliases.bash" "$BASH_IT/enabled/750---b.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/750---b.aliases.bash"

	load "${BASH_IT?}/bash_it.sh"

	run alias test_alias &> /dev/null
	assert_success
	assert_line -n 0 "alias test_alias='a'"
}

@test "bash-it: legacy per-type enabled directories are ignored with a migrate warning" {
	run ln -s "${BASH_IT?}/aliases/available/a.aliases.bash" "${BASH_IT?}/aliases/enabled/150---a.aliases.bash"
	assert_link_exist "${BASH_IT?}/aliases/enabled/150---a.aliases.bash"

	run bash -c 'source "${BASH_IT}/bash_it.sh" && { alias test_alias || true; }' 2>&1
	assert_success
	assert_output --partial "bash-it migrate"
	refute_output --partial "alias test_alias="
}

@test "bash-it: no migrate warning without legacy enabled directories" {
	run bash -c 'source "${BASH_IT}/bash_it.sh"' 2>&1
	assert_success
	refute_output --partial "bash-it migrate"
}

@test "bash-it: reloader works under set -u without arguments" {
	run bash -c 'source "${BASH_IT}/bash_it.sh"; set -u; source "${BASH_IT}/scripts/reloader.bash"' 2>&1
	assert_success
}

@test "bash-it: reloader with 'alias' loads only aliases from the global enabled directory" {
	run ln -s "${BASH_IT?}/aliases/available/a.aliases.bash" "${BASH_IT?}/enabled/950---a.aliases.bash"
	run ln -s "${BASH_IT?}/plugins/available/c.plugin.bash" "${BASH_IT?}/enabled/850---c.plugin.bash"

	run bash -c 'source "${BASH_IT}/bash_it.sh"; unalias test_alias; source "${BASH_IT}/scripts/reloader.bash" alias; alias test_alias'
	assert_success
	assert_output "alias test_alias='a'"
}

@test "bash-it: reloader with 'plugin' loads only plugins from the global enabled directory" {
	run ln -s "${BASH_IT?}/aliases/available/a.aliases.bash" "${BASH_IT?}/enabled/950---a.aliases.bash"
	run ln -s "${BASH_IT?}/plugins/available/c.plugin.bash" "${BASH_IT?}/enabled/850---c.plugin.bash"

	run bash -c 'source "${BASH_IT}/bash_it.sh"; unalias test_alias; source "${BASH_IT}/scripts/reloader.bash" plugin; alias test_alias'
	assert_success
	assert_output "alias test_alias='c'"
}

@test "bash-it: load global aliases in order" {
	run ln -s "${BASH_IT?}/plugins/available/base.plugin.bash" "${BASH_IT?}/enabled/250---base.plugin.bash"
	assert_link_exist "${BASH_IT?}/enabled/250---base.plugin.bash"

	run ln -s "${BASH_IT?}/aliases/available/a.aliases.bash" "${BASH_IT?}/enabled/150---a.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/150---a.aliases.bash"
	run ln -s "${BASH_IT?}/aliases/available/b.aliases.bash" "${BASH_IT?}/enabled/150---b.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/150---b.aliases.bash"

	# The `test_alias` alias should not exist
	run alias test_alias &> /dev/null
	assert_failure

	run ln -s "$BASH_IT/aliases/available/a.aliases.bash" "$BASH_IT/enabled/750---a.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/750---a.aliases.bash"
	run ln -s "$BASH_IT/aliases/available/b.aliases.bash" "$BASH_IT/enabled/750---b.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/750---b.aliases.bash"

	load "${BASH_IT?}/bash_it.sh"

	run alias test_alias &> /dev/null
	assert_success
	assert_line -n 0 "alias test_alias='b'"
}

@test "bash-it: load global aliases in priority order" {
	run ln -s "${BASH_IT?}/plugins/available/base.plugin.bash" "${BASH_IT?}/enabled/250---base.plugin.bash"
	assert_link_exist "${BASH_IT?}/enabled/250---base.plugin.bash"

	run ln -s "${BASH_IT?}/aliases/available/a.aliases.bash" "${BASH_IT?}/enabled/175---a.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/175---a.aliases.bash"
	run ln -s "${BASH_IT?}/aliases/available/b.aliases.bash" "${BASH_IT?}/enabled/150---b.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/150---b.aliases.bash"

	# The `test_alias` alias should not exist
	run alias test_alias &> /dev/null
	assert_failure

	run ln -s "$BASH_IT/aliases/available/a.aliases.bash" "$BASH_IT/enabled/755---a.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/755---a.aliases.bash"
	run ln -s "$BASH_IT/aliases/available/b.aliases.bash" "$BASH_IT/enabled/750---b.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/750---b.aliases.bash"

	load "${BASH_IT?}/bash_it.sh"

	run alias test_alias &> /dev/null
	assert_success
	assert_line -n 0 "alias test_alias='a'"
}

@test "bash-it: load global aliases and plugins in priority order" {
	run ln -s "${BASH_IT?}/plugins/available/base.plugin.bash" "${BASH_IT?}/enabled/250---base.plugin.bash"
	assert_link_exist "${BASH_IT?}/enabled/250---base.plugin.bash"

	run ln -s "${BASH_IT?}/aliases/available/a.aliases.bash" "${BASH_IT?}/enabled/150---a.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/150---a.aliases.bash"
	run ln -s "${BASH_IT?}/aliases/available/b.aliases.bash" "${BASH_IT?}/enabled/150---b.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/150---b.aliases.bash"
	run ln -s "${BASH_IT?}/plugins/available/c.plugin.bash" "${BASH_IT?}/enabled/250---c.plugin.bash"
	assert_link_exist "${BASH_IT?}/enabled/250---c.plugin.bash"

	# The `test_alias` alias should not exist
	run alias test_alias &> /dev/null
	assert_failure

	run ln -s "$BASH_IT/aliases/available/a.aliases.bash" "$BASH_IT/enabled/755---a.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/755---a.aliases.bash"
	run ln -s "$BASH_IT/aliases/available/b.aliases.bash" "$BASH_IT/enabled/750---b.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/750---b.aliases.bash"
	run ln -s "$BASH_IT/plugins/available/c.plugin.bash" "$BASH_IT/enabled/850---c.plugin.bash"
	assert_link_exist "$BASH_IT/enabled/850---c.plugin.bash"

	load "${BASH_IT?}/bash_it.sh"

	run alias test_alias &> /dev/null
	assert_success
	assert_line -n 0 "alias test_alias='c'"
}

@test "bash-it: load global aliases and plugins in priority order, with one alias higher than plugins" {
	run ln -s "${BASH_IT?}/plugins/available/base.plugin.bash" "${BASH_IT?}/enabled/250---base.plugin.bash"
	assert_link_exist "${BASH_IT?}/enabled/250---base.plugin.bash"

	run ln -s "${BASH_IT?}/aliases/available/a.aliases.bash" "${BASH_IT?}/enabled/350---a.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/350---a.aliases.bash"
	run ln -s "${BASH_IT?}/aliases/available/b.aliases.bash" "${BASH_IT?}/enabled/150---b.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/150---b.aliases.bash"
	run ln -s "${BASH_IT?}/plugins/available/c.plugin.bash" "${BASH_IT?}/enabled/250---c.plugin.bash"
	assert_link_exist "${BASH_IT?}/enabled/250---c.plugin.bash"

	# The `test_alias` alias should not exist
	run alias test_alias &> /dev/null
	assert_failure

	run ln -s "$BASH_IT/aliases/available/a.aliases.bash" "$BASH_IT/enabled/950---a.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/950---a.aliases.bash"
	run ln -s "$BASH_IT/aliases/available/b.aliases.bash" "$BASH_IT/enabled/750---b.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/750---b.aliases.bash"
	run ln -s "$BASH_IT/plugins/available/c.plugin.bash" "$BASH_IT/enabled/850---c.plugin.bash"
	assert_link_exist "$BASH_IT/enabled/850---c.plugin.bash"

	load "${BASH_IT?}/bash_it.sh"

	run alias test_alias &> /dev/null
	assert_success
	# This will be a, loaded from the a aliases, since the global directory
	# loads all component types at once
	assert_line -n 0 "alias test_alias='a'"
}

@test "bash-it: load enabled aliases from new structure, priority-based" {
	run ln -s "${BASH_IT?}/aliases/available/atom.aliases.bash" "${BASH_IT?}/enabled/150---atom.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/150---atom.aliases.bash"
	run ln -s "${BASH_IT?}/plugins/available/base.plugin.bash" "${BASH_IT?}/enabled/250---base.plugin.bash"
	assert_link_exist "${BASH_IT?}/enabled/250---base.plugin.bash"

	mkdir -p "$BASH_IT/enabled"
	run ln -s "$BASH_IT/aliases/available/atom.aliases.bash" "$BASH_IT/enabled/750---atom.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/750---atom.aliases.bash"
	run ln -s "$BASH_IT/plugins/available/base.plugin.bash" "$BASH_IT/enabled/250---base.plugin.bash"
	assert_link_exist "$BASH_IT/enabled/250---base.plugin.bash"

	# The `ah` alias should not exist
	run alias ah &> /dev/null
	assert_failure

	load "${BASH_IT?}/bash_it.sh"

	run alias ah &> /dev/null
	assert_success
}

@test "bash-it: load enabled aliases from global structure, priority-based" {
	run ln -s "${BASH_IT?}/aliases/available/atom.aliases.bash" "${BASH_IT?}/enabled/150---atom.aliases.bash"
	assert_link_exist "${BASH_IT?}/enabled/150---atom.aliases.bash"
	run ln -s "${BASH_IT?}/plugins/available/base.plugin.bash" "${BASH_IT?}/enabled/250---base.plugin.bash"
	assert_link_exist "${BASH_IT?}/enabled/250---base.plugin.bash"

	run ln -s "$BASH_IT/aliases/available/atom.aliases.bash" "$BASH_IT/enabled/750---atom.aliases.bash"
	assert_link_exist "$BASH_IT/enabled/750---atom.aliases.bash"
	run ln -s "$BASH_IT/plugins/available/base.plugin.bash" "$BASH_IT/enabled/250---base.plugin.bash"
	assert_link_exist "$BASH_IT/enabled/250---base.plugin.bash"

	# The `ah` alias should not exist
	run alias ah &> /dev/null
	assert_failure

	load "${BASH_IT?}/bash_it.sh"

	run alias ah &> /dev/null
	assert_success
}
