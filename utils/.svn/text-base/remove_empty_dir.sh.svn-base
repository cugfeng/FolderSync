# !/bin/bash

# Remove empty directorys
function remove_empty_dir()
{
	target_dir=$1

	if [ ! -d "$target_dir" ]; then
		echo "[Error] Target directory '$target_dir' does not exist." >&2
		return
	fi
	
	dir_list=/tmp/dir_list.log
	
	pushd "$target_dir" >/dev/null
	# Generate directory lists
	find . -type d -print0 | xargs -0 printf "%s\n" > $dir_list
	
	# Do delete or move to trash
	cat $dir_list | while read dir; do
		if [ -z "$dir" ]; then
			continue
		fi
	
		content=$(ls "$dir")
		if [ -z "$content" ]; then
			echo "Delete empty directory: $dir"
			rmdir "$dir"
		fi
	done
	popd
	
	# Delete file lists
	rm $dir_list
}

cd /media/Data_Backup && remove_empty_dir Movie

