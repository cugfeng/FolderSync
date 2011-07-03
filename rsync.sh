#!/bin/bash

function rsync_backup()
{
	echo "====== Backup ======"
	begin_time=$(date $TimeFormat)

	length=${#SyncDirList[@]}
	for ((i=0; i<length; i++)); do
		echo "Sync dir: ${SyncDirList[$i]}"
		rsync -auz --delete --progress --log-file=$LogFile "${SyncDirList[$i]}" "$DestDir"
	done
	
	length=${#BakDirList[@]}
	for ((i=0; i<length; i++)); do
		echo "Sync dir: ${BakDirList[$i]}"
		rsync -auz --progress --log-file=$LogFile "${BakDirList[$i]}" "$DestDir"
	done

	end_time=$(date $TimeFormat)
	echo "[Begin time] $begin_time"
	echo "[End   time] $end_time"
}

