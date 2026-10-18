# shellcheck shell=bash

__ngrok_completion() {
	# shellcheck disable=SC2155
	local prev=$(_get_pword)
	# shellcheck disable=SC2155
	local curr=$(_get_cword)

	local BASE_NO_CONF="--log --log-format --log-level --help"
	local BASE="--config $BASE_NO_CONF"
	local DEFAULT="$BASE --authtoken --region"

	case $prev in
		authtoken)
			_bash-it-compgen -W "$BASE" -- "$curr"
			;;
		http)
			_bash-it-compgen -W "$DEFAULT --auth --bind-tls --host-header --hostname --inspect --subdomain" -- "$curr"
			;;
		start)
			_bash-it-compgen -W "$DEFAULT --all --none" -- "$curr"
			;;
		tcp)
			_bash-it-compgen -W "$DEFAULT --remote-addr" -- "$curr"
			;;
		tls)
			_bash-it-compgen -W "$DEFAULT --client-cas --crt --hostname --key --subdomain" -- "$curr"
			;;
		update)
			_bash-it-compgen -W "$BASE_NO_CONF --channel" -- "$curr"
			;;
		ngrok)
			_bash-it-compgen -W "authtoken credits http start tcp tls update version help" -- "$curr"
			;;
		*) ;;

	esac
}

complete -F __ngrok_completion ngrok
