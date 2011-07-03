#!/bin/bash

# UUID of source partation (iTunes)
SrcUuidA=D272B8BF72B8AA1D
# UUID of source partation (Music & Tv_Play & Movie)
SrcUUidB=1610EBBD10EBA1CB
# UUID of destation partation 160GB 2.5inch hard disk
DestUuidA=8002EA8D02EA878C
# UUID of destation partation 500GB 3.5inch hard disk
#DestUuidA=3888A92588A8E29C

# UUID of mount partations
MountUuidList=($SrcUuidA $SrcUUidB $DestUuidA)
MoutedPtList=()

# Mount path
MountPath=/tmp

# Destation is the same as source
SyncDirList=()
SyncDirList[0]="$HOME"
SyncDirList[1]="$MountPath/$SrcUuidA/Documents and Settings/cugfeng/Music/iTunes"

# Destation is the backup of source, which may have more files than source
BakDirList=()
BakDirList[0]="$MountPath/$SrcUUidB/Music"

# Destation directory
DestDir=$MountPath/$DestUuidA

# Trash directory
TrashDir=$DestDir/Trash

# Delete or move to trash. If false, delete; otherwise, move to trash
FakeDelete=true

# Log file
LogFile=/tmp/rsync.log

# Time format
TimeFormat="+%F_%T"

# Use cp or rsync. If true, use cp; if false, use rsync.
UseCp=true

