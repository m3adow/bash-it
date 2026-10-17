#!/usr/bin/env bash

# Lint all files; vendor/ is excluded by .pre-commit-config.yaml.
#
# We clear the BASH_IT variable to help the shellcheck checker
# identify source includes within our scripts that require a
# 'source' directive.  For more information, see:
#
#    "Shellcheck SC1090 - Can't follow non-constant source"
#     https://www.shellcheck.net/wiki/SC1090
#

if command -v prek > /dev/null 2>&1; then
	BASH_IT='' prek run --all-files
else
	BASH_IT='' pre-commit run --all-files
fi
