#! /bin

# Item file format: 
# SRC+DEST
# SRC+DEST
# ......
ItemFile=/tmp/shell_var.tmp
Top=$(pwd)

for line in $(cat $ItemFile); do
	src=$(echo $line | cut -d '+' -f 1)
	dest=$(echo $line | cut -d '+' -f 2)

	for file in $(find $Top -name "*.sh" -type f 2>/dev/null); do
		sed -i "s/$src/$dest/g" $file 
	done
done

