#!/usr/bin/env bash
SCRIPT_DIR=$(dirname `readlink -f $0`)
source $SCRIPT_DIR/init-steam-backup-vars.sh

cd $STEAM_SAVES_DIR
$BIN_DIR/ludusavi backup --force --path $STEAM_SAVES_DIR/ludusavi-backup
LD_PRELOAD="/usr/lib/libcurl.so.4" $BIN_DIR/git-sync -s -n

## For logs, type this in Launch Options :
# %command% ; /path/to/script/my-steam-backup.sh > /tmp/$(date +'%F_%H.%M.%S').testlog ; ping github.com -c 2 > /tmp/$(date +'%F_%H.%M.%S').testping

## Or, if you don't need logs and only want to backup, type this in Launch Options :
# %command% ; /path/to/script/my-steam-backup.sh
