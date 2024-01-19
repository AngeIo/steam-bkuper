# Steam BKUPER
This script is designed to backup all Steam game save files automatically (optimized for Steam Deck).

## Why this script?
I played a lot on my Steam Deck. One day, I left my console charging all night and when I wanted to get back in game, the OS refused to boot and I was stuck on BIOS. The SSD decided to stop working.
I was a bit worried at first, but then I realised that my game saves should be safe in the Steam Cloud.

But, of course, **I was wrong**.

Why? Because some games do not provide Steam Cloud, like `Just Cause 3`.

This script has been specially made to ensure that those who use it NEVER EVER lose their precious game saves in such cases.

## Features
- [x] Easy to install with a single command
- [x] Use Git for backup versioning
- [x] While game is starting and/or when game is closed, do a backup
- [x] "Launch Options" are automatically set on all games of your Steam library

## Prerequisites
- Tested on SteamOS 3.5.7 (Arch Linux) but could be working on other distros
- Git

## Usage
### (Optional) Connect to your Steam Deck
If you want to easily access your Steam Deck from your main computer, follow these steps:

You have to create a password before you can access your console with SSH.
First, switch to Desktop Mode, then open the terminal called `Konsole`.
Type this command to define your new password:
```
passwd
```
Now start SSH service and type your password:
```
sudo systemctl start sshd
```
Enable the SSH service so it stays up even after a reboot of the Steam Deck (make it accessible while in Game Mode too!):
```
sudo systemctl enable sshd
```
For more information, you can check this FAQ from Valve: https://help.steampowered.com/en/faqs/view/671A-4453-E8D2-323C

### Installation
Clone the repository:
```
git clone https://github.com/AngeIo/steam-bkuper
cd steam-bkuper
```

#### Variables configuration
You have to edit the variables to make sure everything installs in the correct paths and the script behaves the way you want, here's how:

- Rename `.env.template` to `.env`.
- Create a new repository on GitLab, GitHub, or both with the name of your choice, in my example, this repo is called `steam-saves`. Then, copy your 2 URLs respectively in `STEAM_SAVES_REPO` and `STEAM_SAVES_REPO2` variables (or only `STEAM_SAVES_REPO` if you have one).
- (Optional) Find your `AccountID`/`Friend Code` and put it in `STEAM_ACCOUNTID` (get it from https://steamcommunity.com/id/YOUR_USERNAME/friends/add or https://steamdb.info/calculator/)
- Modify all other variables in `.env` to match with your environment.

### Apply script to games
Here are examples of behaviour you can apply by modifying the `STEAM_LOPTS` variable in `.env` so "Launch Options" are set automatically:

#### Backup after the game is closed (default)
```
%command%;/path/to/script/my-steam-backup.sh
```

#### Backup before the game is starting
```
/path/to/script/my-steam-backup.sh;%command%
```

#### Backup before the game is starting and after the game is closed
```
/path/to/script/my-steam-backup.sh;%command%;/path/to/script/my-steam-backup.sh
```

### Final touches
> [!WARNING]
> All your Launch Options will be overwritten by the following script!
>
> But don't worry, you can always rollback:
>
> A copy of `localconfig.vdf` is created and the script gives you a command to easily restore it back!

Once you are satisfied with your variables in the `.env` file, you can launch the installation:
```
./steam-backup-setup.sh
```
To allow the git repositories to push content to remote in the background while in "Game Mode", you must enter these commands the first time:
```
# Git will store your credentials so you don't have to type them next time
git config --global credential.helper store
```
Then run `$BIN_DIR/my-steam-backup.sh` from your terminal so you are asked to type your git login and password for each repositories once to store them:
```
/path/to/script/my-steam-backup.sh
```
You are now ready to backup your whole Steam library!

### How does it work?
To make sure everything is working:
- Start a game with Launch Options configured
- Close it
- (Yes, it's _that_ simple)

Check your remote Git repository (GitHub, GitLab, etc.), if the directory `$STEAM_SAVES_DIR/ludusavi-backup` is populated with your save files then congratulations!

You are now safe from any defects your Steam Deck/PC may encounter!

### Final files tree
Here is what your directories should look like in `STEAM_SAVES_DIR`:
```
(deck@asundeck steam-saves)$ tree
.
├── ludusavi-backup
│   ├── Alien_ Isolation
│   │   ├── drive-0
│   │   │   └── home
│   │   │       └── deck
│   │   └── mapping.yaml

[...]

│   └── Uno (2016)
│       ├── drive-0
│       │   └── home
│       │       └── deck
│       └── mapping.yaml
├── README.md
└── typescript

XX directories, XX files
(deck@asundeck steam-saves)$
```

## Save game restoration
Here's how you can restore your backups:
- Launch `ludusavi`, a nice GUI should open.
- Click on `Restore Mode`.
- In `Restore from` choose the `ludusavi-backup` directory inside your personal git repository: `STEAM_SAVES_DIR` (contains your save files).
- Click on `Preview`, the list of backed up games should appear.
- Select the games you want to restore by ticking them.
- Click on `Restore`.
- Enjoy!

## Contribution
I know this script is far from perfect, please create pull requests if you want to help me improve it. Thanks!

## Credits
- [Matthew Kennerly](https://github.com/mtkennerly) and contributors for [`ludusavi`](https://github.com/mtkennerly/ludusavi)
- [Simon Thum](https://github.com/simonthum) and contributors for [`git-sync`](https://github.com/simonthum/git-sync)
- [Ryan Beaman](https://github.com/WisdomWolf) for his contributions from [his personal public fork](https://github.com/WisdomWolf/steam-bkuper)
- [frostworx](https://github.com/frostworx) for [his script to set Steam launch options on all games automatically](https://github.com/FeralInteractive/gamemode/issues/177)
- Angelo
