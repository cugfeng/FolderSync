#!/bin/bash

function kill_tree()
{
	local _pid=$1
	
	echo "[Info] kill_tree $_pid"
	for _child in $(ps -o pid --no-headers --ppid $_pid) ; do
		kill_tree $_child
	done

	echo "[Info] Kill process $_pid"
	kill -2 $_pid 2>/dev/null
}

