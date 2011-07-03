#!/bin/bash

function mount_check()
{
	echo "====== Check ======"
	index=-1
	for uuid in ${MountUuidList[@]}; do
		let index++
		info=$(cat /proc/self/mountstats | grep $uuid)
		if [ -n "$info" ]; then
			MoutedPtList[$index]=$(echo $info | cut -d ' ' -f 5)
			continue
		fi
	
		name=$($Sudo blkid | grep $uuid | cut -d ':' -f 1)
		if [ -n "$name" ]; then
			info=$(cat /proc/self/mountstats | grep $name)
			if [ -n "$info" ]; then
				MoutedPtList[$index]=$(echo $info | cut -d ' ' -f 5)
				continue
			fi
		fi
	
		MoutedPtList[$index]=None
	done
	
	length=${#MountUuidList[@]}
	for ((i=0; i<length; i++)); do
		printf '%16s: %s\n' ${MountUuidList[$i]} ${MoutedPtList[$i]}
	done
}

function do_mount_fail_check()
{
	uuid=$1
	status=$2

	if [ "$status" -ne 0 ]; then
		echo "[Error] Mount $uuid failed." >&2
		exit -1
	fi
}

function do_mount()
{
	echo "====== Mount ======"
	index=-1
	for uuid in ${MountUuidList[@]}; do
		let index++
		mkdir -p $MountPath/$uuid
		if [ "${MoutedPtList[$index]}" = "$MountPath/$uuid" ]; then
			echo "$uuid has been mounted on $MountPath/$uuid"
		elif [ "${MoutedPtList[$index]}" = "None" ]; then
			echo "Mount $uuid on $MountPath/$uuid"
			$Sudo mount -o ro -U $uuid -t ntfs $MountPath/$uuid
			do_mount_fail_check "$uuid" $?
		else
			echo "Move mount tree from ${MoutedPtList[$index]} to $MountPath/$uuid"
			$Sudo mount --move ${MoutedPtList[$index]} $MountPath/$uuid
			do_mount_fail_check "$uuid" $?
		fi
	done
}

function do_umount()
{
	echo "====== Umount ======"
	for uuid in ${MountUuidList[@]}; do
		echo "Umount partation: $uuid"
		$Sudo umount $MountPath/$uuid
	done
}

