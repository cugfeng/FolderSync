#!/bin/bash

# Make sure only root can run this script
function root_check()
{
	if [ "$(id -u)" -ne 0 ]; then
		echo "[Error] Only root can run this script!!!" >&2
		echo "Use 'sudo $0' instead!!!" >&2
		exit 1
	fi
}

# Check whether the current user is root or not
function is_user_root()
{
	if [ "$(id -u)" -eq 0 ]; then
		echo "yes"
	else
		echo "no"
	fi
}

