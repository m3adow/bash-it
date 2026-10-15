# shellcheck shell=bash

cite "about-completion"
about-completion "dart - programming language optimized for client-side development"
group "mobile"
url "https://dart.dev/"

__dart_completion() {
	# shellcheck disable=SC2155
	local prev=$(_get_pword)
	# shellcheck disable=SC2155
	local curr=$(_get_cword)

	local HELP="--help -h"
	local VERBOSE="-v --verbose"

	case $prev in
		analyze)
			_bash-it-compgen -W "$HELP --fatal-infos --no-fatal-warnings --fatal-warnings" -- "$curr"
			;;
		compile)
			_bash-it-compgen -W "$HELP aot-snapshot exe js jit-snapshot kernel" -- "$curr"
			;;
		create)
			_bash-it-compgen -W "$HELP --template -t --no-pub --pub --force" -- "$curr"
			;;
		-t | --template)
			_bash-it-compgen -W "console-simple console-full package-simple web-simple" -- "$curr"
			;;
		format)
			_bash-it-compgen -W "$HELP $VERBOSE -o --output --fix -l --line-length" -- "$curr"
			;;
		pub)
			_bash-it-compgen -W "$HELP $VERBOSE --version --no-trace --trace --verbosity cache deps downgrade get global logout outdated publish run upgrade uploader version" -- "$curr"
			;;
		run)
			_bash-it-compgen -W "$HELP --observe --enable-vm-service --no-pause-isolates-on-exit --no-pause-isolates-on-unhandled-exceptions --no-warn-on-pause-with-no-debugger --pause-isolates-on-exit --pause-isolates-on-unhandled-exceptions --warn-on-pause-with-no-debugger" -- "$curr"
			;;
		dart)
			_bash-it-compgen -W "$HELP $VERBOSE --version --enable-analytics --disable-analytics help analyze compile create format pub run test" -- "$curr"
			;;
	esac
}

complete -F __dart_completion dart
