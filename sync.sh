#!/bin/bash

export Top=$(pwd)
export Utils=$Top/utils

source $Utils/check-root.sh

export Test=false
export Sudo=

function usage()
{
	echo "Usage: $0 [debug] [test] [quiet]" >&2
	exit 1
}

if [ "$(is_user_root)" = "no" ]; then
	Sudo=sudo
fi

BashOpt=
Quiet=false
while [ -n "$1" ]; do
	case $1 in
		debug)
			BashOpt=-x
			;;
		test)
			Test=true
			;;
		quiet)
			Quiet=true
			;;
		*)
			echo "[Error] '$1' not recognized." >&2
			usage
			;;
	esac
	shift
done

SyncScript=$Top/sync_all.sh
AwkScript=$Utils/time-tunnel.awk
SyncLock=/tmp/file-sync.lock
SyncLog=/tmp/file-sync.log

# Exit when user press CTRL+C or send signal kill -9 $PID
trap "rm $SyncLock && kill -9 -$$" INT TERM

if [ -f $SyncLock ]; then
	echo "[Error] Another instance is active." >&2
	exit 1
fi

if [ -e $SyncScript ];
then
	echo $$ > $SyncLock
	if [ "$Quiet" = true ]; then
		bash $BashOpt $SyncScript 2>&1 | awk -f $AwkScript >> $SyncLog
	else
		bash $BashOpt $SyncScript 2>&1 | awk -f $AwkScript | tee -a $SyncLog
	fi
	rm $SyncLock 
fi

