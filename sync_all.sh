#!/bin/bash

if [ "$Test" = false ]; then
	source $Top/config.sh
else
	source $Top/config-test.sh
fi
source $Top/mount.sh
source $Top/rsync.sh
source $Top/sync_impl.sh

mount_check && do_mount

if [ "$UseCp" = true ]; then
	cp_backup	
else
	rsync_backup
fi

do_umount

