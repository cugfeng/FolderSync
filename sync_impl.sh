# !/bin/sh

# Delete file which is in dest dir but not in source dir
function do_delete()
{
	src_dir=$1
	dest_dir=$2
	fake_delete=$3

	echo "[Info] Function   : do_delete"
	echo "[Info] Source     : $src_dir"
	echo "[Info] Destination: $dest_dir"

	if [ ! -d "$src_dir" ]; then
		echo "[Error] Source directory does not exist." >&2
		return
	fi
	if [ ! -d "$dest_dir" ]; then
		echo "[Error] Destination directory does not exist." >&2
		return
	fi
	if [ "$src_dir" = "$dest_dir" ]; then
		echo "[Error] Source directory is the same as destination directory." >&2
		return
	fi
	
	src_file_list=$(mktemp)
	dest_file_list=$(mktemp)
	# File which is in destination directory but not in source directory should be deleted
	del_file_list=$(mktemp)
	
	# Generate file lists
	(pushd "$src_dir" && find . -name "*" -type f -print0 | xargs -0 printf "%s\n" > $src_file_list && popd) >/dev/null
	(pushd "$dest_dir" && find . -name "*" -type f -print0 | xargs -0 printf "%s\n" > $dest_file_list && popd) >/dev/null
	grep -F -f $src_file_list $dest_file_list -v > $del_file_list
	
	# Do delete or move to trash
	pushd "$dest_dir" >/dev/null
	cat $del_file_list | while read bfile; do
		if [ -z "$bfile" ]; then
			continue
		fi
	
		echo "Delete file: $bfile"
		if [ "$fake_delete" = "false" ]; then
			rm "$bfile"
		else
			mv "$bfile" $TrashDir
		fi
	done
	popd >/dev/null
	
	# Delete file lists
	rm $src_file_list
	rm $dest_file_list
	rm $del_file_list
}

function size_compare()
{
	file_left=$1
	file_right=$2

	size_left=$(stat -c %s "$file_left")
	size_right=$(stat -c %s "$file_right")

	if [ "$size_left" -eq "$size_right" ]; then
		echo "0"
	else
		echo "1"
	fi
}

function do_cp_backup()
{
	src_dir=$1
	dest_dir=$2

	echo "[Info] Function   : do_cp_backup"
	echo "[Info] Source     : $src_dir"
	echo "[Info] Destination: $dest_dir"

	if [ ! -d "$src_dir" ]; then
		echo "[Error] Source directory does not exist." >&2
		return
	fi
	if [ "$src_dir" = "$dest_dir" ]; then
		echo "[Error] Source directory is the same as destination directory." >&2
		return
	fi
	
	if [ ! -d "$dest_dir" ]; then
		echo "Create directory '$dest_dir'"
		mkdir -p "$dest_dir"
	fi
	if [ ! -d $TrashDir ]; then
		echo "Create directory '$TrashDir'"
		mkdir -p $TrashDir
	fi

	tmpfile=$(mktemp)
	
	pushd "$src_dir" >/dev/null
	find . -name "*" -type f -print0 | xargs -0 printf "%s\n" > $tmpfile
	cat $tmpfile | while read bfile; do
		if [ -z "$bfile" ]; then
			continue
		fi
	
		copy=false
		# File does not exist
		if [ ! -e "$dest_dir"/"$bfile" ]; then
			copy=true
		# Source file is newer than destination file
		elif [ "$bfile" -nt "$dest_dir"/"$bfile" ]; then
			copy=true
		# Source file size is not equal to destination file size
		elif [ "$(size_compare "$dest_dir"/"$bfile" "$bfile")" -ne 0 ]; then
			copy=true
		fi

		if [ "$copy" = true ]; then
			dir=$(dirname "$bfile")
			if [ ! -d "$dest_dir"/"$dir" ]; then
				mkdir -p "$dest_dir"/"$dir"
			fi
			echo "Copy $bfile"
			cp -p "$bfile" "$dest_dir"/"$bfile"
		else
			echo "File exist: $bfile"
		fi
	done
	popd >/dev/null

	rm $tmpfile
}

function cp_backup()
{
	echo "====== Backup ======"
	begin_time=$(date $TimeFormat)

	length=${#SyncDirList[@]}
	for ((i=0; i<length; i++)); do
		echo "Sync dir: ${SyncDirList[$i]}"
		base=$(basename "${SyncDirList[$i]}")
		do_cp_backup "${SyncDirList[$i]}" "$DestDir"/"$base"
		do_delete "${SyncDirList[$i]}" "$DestDir"/"$base" $FakeDelete
	done
	
	length=${#BakDirList[@]}
	for ((i=0; i<length; i++)); do
		echo "Sync dir: ${BakDirList[$i]}"
		base=$(basename "${BakDirList[$i]}")
		do_cp_backup "${BakDirList[$i]}" "$DestDir"/"$base"
	done

	end_time=$(date $TimeFormat)
	echo "[Begin time] $begin_time"
	echo "[End   time] $end_time"
}

