#!/usr/bin/env bash
set -e

# Get current timestamp
TIMEEPOCH=$(date +'%F_%H.%M.%S')
# Get current script's directory
SCRIPT_DIR=$(dirname `readlink -f $0`)
ln -s $SCRIPT_DIR/.env $HOME/steam-bkuper.env &>/dev/null || true
source $SCRIPT_DIR/init-steam-backup-vars.sh

# If $STEAM_BKUPER_DIR/.env don't exist, exit
if [ ! -f "$STEAM_BKUPER_DIR/.env" ]; then
    echo ".env file not found. Please make sure the file exists in the current directory. Is STEAM_BKUPER_DIR path correct?"
    exit 1
fi

cd $BIN_DIR
wget -qc https://github.com/mtkennerly/ludusavi/releases/download/$LUDUSAVI_VER/$LUDUSAVI_FILE -O $LUDUSAVI_FILE
unzip -oq $LUDUSAVI_FILE
rm $LUDUSAVI_FILE
echo "Installed ludusavi $LUDUSAVI_VER"

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

echo "Git setup is ready"

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
        printf "Looks like Steam is running... please close it before proceeding and press Enter to continue or CTRL+C to exit the current script.\nQuick tip: In .env file, put "NULL" in STEAM_LOPTS to prevent adding Launch Options automatically and skipping this message! " && read ans
      while pgrep -x "$process_name" > /dev/null; do
        printf "Looks like Steam is STILL running... please close it before proceeding and press Enter to continue or CTRL+C to exit the current script.\nQuick tip: In .env file, put "NULL" in STEAM_LOPTS to prevent adding Launch Options automatically and skipping this message! " && read ans
      done
    fi
    ###

    ###
    # Edit the localconfig.vdf file to add the command to each of your games' launch options
    LCVDFO="$HOME/.steam/steam/userdata/$STEAM_ACCOUNTID/config/localconfig.vdf"
    LCVDF="$LCVDFO.bak.$TIMEEPOCH"
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
    echo "If you want to restore the previous version of your localconfig.vdf, type the following commands:"
    echo "cp $LCVDFO $LCVDFO.bak"
    echo "cp $LCVDF $LCVDFO"
    echo ""
    ###

    ###
    # Define STEAM_LAST_LOPTS variable in $STEAM_BKUPER_DIR/.env
    # Check if the line containing STEAM_LAST_LOPTS exists (ignoring comments)
    if grep -q "^export STEAM_LAST_LOPTS=" "$STEAM_BKUPER_DIR/.env"; then
        # Use sed to replace the value of STEAM_LAST_LOPTS
        sed -i --expression "s@^export STEAM_LAST_LOPTS=\"[^\"]*\"@export STEAM_LAST_LOPTS=\"$STEAM_LOPTS\"@" $STEAM_BKUPER_DIR/.env
        echo "Successfully updated STEAM_LAST_LOPTS in .env file."
    else
        # If the line doesn't exist, add it to a new line at the end of the file
        echo -e "\nexport STEAM_LAST_LOPTS=\"$STEAM_LOPTS\"" >> $STEAM_BKUPER_DIR/.env
        echo "Added STEAM_LAST_LOPTS to .env file."
    fi
    ###

  else
    echo "Launch Options are already added to your Steam library!"
  fi
else
  echo "Launch Options' automatic setup is disabled!"
fi