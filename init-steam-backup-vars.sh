#!/usr/bin/env bash
set -e

if [ -f "$HOME/steam-bkuper.env" ]; then
    export $(grep -v '^#' ~/steam-bkuper.env | xargs)
fi

export BIN_DIR="$HOME/bin"
mkdir -p $BIN_DIR

export STEAM_BKUPER_DIR="${STEAM_BKUPER_DIR:-$HOME/.local/share/steam-bkuper}"
export STEAM_SAVES_DIR="${STEAM_SAVES_DIR:-$HOME/.local/share/steam-saves}"
export STEAM_BKUPER_REPO="${STEAM_BKUPER_REPO:-'https://github.com/AngeIo/steam-bkuper'}"
export STEAM_SAVES_REPO="${STEAM_SAVES_REPO:?}"
export STEAM_PATH="${STEAM_PATH:-'/home/deck/.local/share/Steam/userdata'}"
export STEAM_LOPTS="${STEAM_LOPTS:-%command%;$BIN_DIR/my-steam-backup.sh}"

# Uncomment for debugging
# echo "STEAM_BKUPER_DIR = $STEAM_BKUPER_DIR"
# echo "STEAM_SAVES_DIR = $STEAM_SAVES_DIR"
# echo "STEAM_BKUPER_REPO = $STEAM_BKUPER_REPO"
# echo "STEAM_SAVES_REPO = $STEAM_SAVES_REPO"
# echo "STEAM_SAVES_REPO2 = $STEAM_SAVES_REPO2"
# echo "STEAM_PATH = $STEAM_PATH"
# echo "STEAM_ACCOUNTID = $STEAM_ACCOUNTID"
# echo "BIN_DIR = $BIN_DIR"
# echo "STEAM_LOPTS = $STEAM_LOPTS"
# echo "STEAM_LAST_LOPTS = $STEAM_LAST_LOPTS"