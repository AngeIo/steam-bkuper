#!/usr/bin/env bash
set -e
SCRIPT_DIR=$(dirname `readlink -f $0`)
source $SCRIPT_DIR/init-steam-backup-vars.sh

cd $BIN_DIR
wget -qc https://github.com/mtkennerly/ludusavi/releases/download/v0.10.0/ludusavi-v0.10.0-linux.zip -O ludusavi-v0.10.0-linux.zip
unzip -oq ludusavi-v0.10.0-linux.zip
rm ludusavi-v0.10.0-linux.zip

if [ ! -d "$STEAM_BKUPER_DIR" ]; then
    git clone $STEAM_BKUPER_REPO $STEAM_BKUPER_DIR
fi

cp $STEAM_BKUPER_DIR/{my-steam-backup.sh,git-sync,init-steam-backup-vars.sh} $BIN_DIR
chmod -R 755 $BIN_DIR
# rm -rf $STEAM_BKUPER_DIR

if [ ! -d "$STEAM_SAVES_DIR" ]; then
    git clone $STEAM_SAVES_REPO $STEAM_SAVES_DIR
fi

cd $STEAM_SAVES_DIR
if [ -n "$STEAM_SAVES_REPO2" ]; then
    git remote add origin-new $STEAM_SAVES_REPO2
fi