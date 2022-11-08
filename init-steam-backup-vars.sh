#!/usr/bin/env bash

export STEAM_BKUPER_DIR="${STEAM_BKUPER_DIR:-$HOME/.local/share/steam-bkuper}"
export STEAM_SAVES_DIR="${STEAM_SAVES_DIR:-$HOME/.local/share/steam-saves}"
export STEAM_BKUPER_REPO="${STEAM_BKUPER_REPO:-'https://github.com/AngeIo/steam-bkuper'}"
export STEAM_SAVES_REPO="${STEAM_SAVES_REPO:?}"
export BIN_DIR=$HOME/bin

mkdir -p $BIN_DIR

# Uncomment for debugging
# echo "STEAM_BKUPER_DIR = $STEAM_BKUPER_DIR"
# echo "STEAM_SAVES_DIR = $STEAM_SAVES_DIR"
# echo "STEAM_BKUPER_REPO = $STEAM_BKUPER_REPO"
# echo "STEAM_SAVES_REPO = $STEAM_SAVES_REPO"
# echo "BIN_DIR = $BIN_DIR"