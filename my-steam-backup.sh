#!/bin/sh
cd /home/deck/Documents/gitrepo/steam-saves
/home/deck/Documents/bin/ludusavi backup --force --path /home/deck/Documents/gitrepo/steam-saves/ludusavi-backup
LD_PRELOAD="/usr/lib/libcurl.so.4" /home/deck/Documents/bin/git-sync -s -n

## For logs, type this in Launch Options :
# %command% ; /home/deck/Documents/bin/my-steam-backup.sh > /tmp/$(date +'%F_%H.%M.%S').testlog ; ping github.com -c 2 > /tmp/$(date +'%F_%H.%M.%S').testping

## Or, if you don't need logs and only want to backup, type this in Launch Options :
# %command% ; /home/deck/Documents/bin/my-steam-backup.sh
