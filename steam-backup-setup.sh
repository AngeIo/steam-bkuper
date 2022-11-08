#!/usr/bin/env bash
SCRIPT_DIR=$(dirname `readlink -f $0`)
$SCRIPT_DIR/init-steam-backup-vars.sh

mkdir $BIN_DIR
cd $HOME/bin
wget https://github.com/mtkennerly/ludusavi/releases/download/v0.10.0/ludusavi-v0.10.0-linux.zip
unzip ludusavi-v0.10.0-linux.zip
rm ludusavi-v0.10.0-linux.zip

git clone $STEAM_BKUPER_REPO $STEAM_BKUPER_DIR

cp $STEAM_BKUPER_DIR/{my-steam-backup.sh,git-sync,init-steam-backup-vars.sh} $BIN_DIR
chmod -R 755 $BIN_DIR
rm -rf $STEAM_BKUPER_DIR
git clone $STEAM_SAVES_REPO $STEAM_SAVES_DIR
cd $STEAM_SAVES_DIR
if [ -n "$STEAM_SAVES_REPO2" ]; then
    git remote add origin-new $STEAM_SAVES_REPO2
fi