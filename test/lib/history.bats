# shellcheck shell=bats

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	setup_libs "history"
}

function local_setup() {
	HISTORY_CALLS="${BATS_TEST_TMPDIR?}/history.calls"
	: > "${HISTORY_CALLS}"
	function history() { echo "history $*" >> "${HISTORY_CALLS?}"; }
	shopt -u histappend
}

function assert_history_calls() {
	run cat "${HISTORY_CALLS?}"
	assert_output "${1?}"
}

@test "lib history: noauto disables both hooks" {
	HISTCONTROL='ignoreboth:noauto'
	_bash-it-history-auto-save
	_bash-it-history-auto-load
	assert_history_calls ''
}

@test "lib history: autoshare saves and fully reloads" {
	HISTCONTROL='ignoreboth:autoshare'
	_bash-it-history-auto-save
	_bash-it-history-auto-load
	assert_history_calls $'history -a\nhistory -a\nhistory -c\nhistory -r'
}

@test "lib history: autosave only appends" {
	HISTCONTROL='autosave'
	_bash-it-history-auto-save
	_bash-it-history-auto-load
	assert_history_calls $'history -a\nhistory -a'
}

@test "lib history: autoload does not save and fully reloads" {
	HISTCONTROL='autoload'
	_bash-it-history-auto-save
	_bash-it-history-auto-load
	assert_history_calls $'history -a\nhistory -c\nhistory -r'
}

@test "lib history: autoloadnew does not save and reads new lines" {
	HISTCONTROL='autoloadnew'
	_bash-it-history-auto-save
	_bash-it-history-auto-load
	assert_history_calls 'history -n'
}

@test "lib history: autosave wins over autoload on load, autoload wins on save" {
	HISTCONTROL='autosave:autoload'
	_bash-it-history-auto-save
	_bash-it-history-auto-load
	assert_history_calls 'history -a'
}

@test "lib history: no auto token appends only with histappend" {
	HISTCONTROL='ignoreboth'
	_bash-it-history-auto-save || true
	shopt -s histappend
	_bash-it-history-auto-save
	_bash-it-history-auto-load
	assert_history_calls 'history -a'
}

@test "lib history: substrings of tokens are not tokens" {
	HISTCONTROL='ignoreboth:xautosavex'
	_bash-it-history-auto-save || true
	_bash-it-history-auto-load
	assert_history_calls ''
}

@test "lib history: unset HISTCONTROL is safe under set -u" {
	unset HISTCONTROL
	set -u
	_bash-it-history-auto-save || true
	_bash-it-history-auto-load
	set +u
	assert_history_calls ''
}

@test "lib history: HISTORY_AUTOSAVE=1 implies autoshare" {
	HISTCONTROL='ignoreboth'
	HISTORY_AUTOSAVE=1
	_bash-it-history-auto-save
	_bash-it-history-auto-load
	unset HISTORY_AUTOSAVE
	assert_history_calls $'history -a\nhistory -a\nhistory -c\nhistory -r'
}

@test "lib history: noauto still wins over HISTORY_AUTOSAVE=1" {
	HISTCONTROL='noauto'
	HISTORY_AUTOSAVE=1
	_bash-it-history-auto-save
	_bash-it-history-auto-load
	unset HISTORY_AUTOSAVE
	assert_history_calls ''
}
