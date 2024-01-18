#!/usr/bin/env bash
set -e

# Get current timestamp
TIMEEPOCH=$(date +'%F_%H.%M.%S')
# Get current script's directory
SCRIPT_DIR=$(dirname `readlink -f $0`)
ln -s $SCRIPT_DIR/.env $HOME/steam-bkuper.env &>/dev/null || true
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

if [ ! -d "$STEAM_SAVES_DIR" ]; then
    git clone $STEAM_SAVES_REPO $STEAM_SAVES_DIR
fi

cd $STEAM_SAVES_DIR
if [ -n "$STEAM_SAVES_REPO2" ]; then
    git remote add origin-new $STEAM_SAVES_REPO2 &>/dev/null || true
fi

# --- Launch Options installation ---

if [[ "$STEAM_LOPTS" != "NULL" ]]; then
  if [[ "$STEAM_LOPTS" != "$STEAM_LAST_LOPTS" ]]; then
    ###
    # Find the smallest directory number in Steam local files
    # Check if the path exists
    if [ ! -d "$STEAM_PATH" ]; then
      echo "Error: The specified path does not exist."
      exit 1
    fi
    # If STEAM_ACCOUNTID is empty or undefined
    if [ ! -n "$STEAM_ACCOUNTID" ]; then
      # Change to the specified path
      cd "$STEAM_PATH" || exit
      # Find all directories in the path
      directories=($(find . -maxdepth 1 -type d -not -name '.' -exec basename {} \;))
      # Check if any directories were found
      if [ ${#directories[@]} -eq 0 ]; then
        echo "Error: No directories found in the specified path."
        exit 1
      fi
      # Initialize variables for the smallest number and corresponding directory
      smallest_number=""
      smallest_dir=""
      # Loop through each directory
      for dir in "${directories[@]}"; do
        # Remove leading zeros from the directory name
        dir_number=$(echo "$dir" | sed 's/^0*//')
        # Check if the current directory is a number
        if [[ "$dir_number" =~ ^[0-9]+$ ]]; then
          # If the smallest_number is empty or the current number is smaller
          if [ -z "$smallest_number" ] || [ "$dir_number" -lt "$smallest_number" ]; then
            smallest_number="$dir_number"
            smallest_dir="$dir"
          fi
        fi
      done
      # Check if a directory with a number was found
      if [ -z "$smallest_dir" ]; then
        echo "Error: No directory with a numeric name found."
        exit 1
      fi
      # DEBUG
      # echo "Smallest directory: $smallest_dir"
      STEAM_ACCOUNTID="$smallest_dir"
    fi
    ###

    ###
    # Asking the user to close Steam before continuing
    process_name="steam"
    # Use pgrep to check if the process is running
    if pgrep -x "$process_name" > /dev/null; then
        printf "%s " "Looks like Steam is running... please close it before proceeding and press Enter to continue or CTRL+C to exit the current script." && read ans
      while pgrep -x "$process_name" > /dev/null; do
        printf "%s " "Looks like Steam is STILL running... please close it before proceeding and press Enter to continue or CTRL+C to exit the current script." && read ans
      done
    fi
    ###

    ###
    # Edit the localconfig.vdf file to add the command to each of your games' launch options
    LCVDFO="$HOME/.steam/steam/userdata/$STEAM_ACCOUNTID/config/localconfig.vdf"
    LCVDF="$LCVDFO.bak.$TIMEEPOCH"
    printf "/!\ WARNING /!\ \nAll your Launch Options will be overwritten by this script!\nAre you sure you want to continue?\nIn case you want to rollback, you could always restore:\n$LCVDF\n\nPress Enter to confirm or CTRL+C to exit the current script. " && read ans
    LOPTS="\\\t\t\t\t\t\t\"LaunchOptions\"		\"$STEAM_LOPTS\""
    if [ ! -f $LCVDF ]; then
      # DEBUG
      # echo "$LCVDF doesn't exist - copying the original"
      if [ ! -f $LCVDFO ]; then
        echo "$LCVDFO doesn't exist as well - giving up"
        exit 1
      else
      cp $LCVDFO $LCVDF
      fi
    fi
    sed -i '/LaunchOptions/d' $LCVDFO
    sed -i '/"Playtime"/i '"$LOPTS"'' $LCVDFO
    echo "Successfully applied your Launch Options to your Steam library!"
    echo ""
    echo "To restore the previous version of localconfig.vdf, type the following commands:"
    echo "cp $LCVDFO $LCVDFO.bak"
    echo "cp $LCVDF $LCVDFO"
    ###

    ###
    # Define STEAM_LAST_LOPTS variable in $STEAM_BKUPER_DIR/.env
    if [ -f "$STEAM_BKUPER_DIR/.env" ]; then
        # Use sed to replace the value of STEAM_LAST_LOPTS
        sed -i --expression "s@export STEAM_LAST_LOPTS=\"[^\"]*\"@export STEAM_LAST_LOPTS=\"${STEAM_LOPTS}\"@" $STEAM_BKUPER_DIR/.env
        echo "Successfully updated STEAM_LAST_LOPTS in .env file."
    else
        echo ".env file not found. Please make sure the file exists in the current directory."
    fi
    ###

  else
    echo "Launch Options are already added to your Steam library!"
  fi
else
  echo "Launch Options' automatic setup is disabled!"
fi