# Steam BKUPER
This script is designed to backup all Steam game save files automatically (optimized for Steam Deck).
## Why this script?
I played a lot on my Steam Deck. One day, I left my console charging all night and when I wanted to get back in game, the OS refused to boot and I was stuck on BIOS. The SSD decided to stop working.
I was a bit worried at first, but then I realised that my game saves should be safe in the Steam Cloud.

But, of course, **I was wrong**.

Why? Because some games do not provide Steam Cloud, like `Just Cause 3`.

I created this script to prevent this from happening one more time and loosing my saves once more.
## Features
- [x] Use Git for backup versioning
- [x] While game is starting and when game is closed, do a backup
- [x] Automatic
## Prerequisites
- Tested on Steam OS 3.0 (Arch Linux) but could be working on other distros
- Git
- ...?
## Usage
### (Optional) Connect to your Steam Deck
If you want to easily access your Steam Deck from your main computer, follow these steps :

You have to create a password before you can access your console with SSH.
First, switch to Desktop Mode, then open the terminal called `Konsole`.
Type this command to define your new password :
```
passwd
```
Now start SSH service and type your password :
```
sudo systemctl start sshd
```
Enable the SSH service so it stays up even after a reboot of the Steam Deck (make it accessible while in Game Mode too!) :
```
sudo systemctl enable sshd
```
For more information, you can check this FAQ from Valve : https://help.steampowered.com/en/faqs/view/671A-4453-E8D2-323C
### Download required files
#### Ludusavi
Tested with version `0.10.0` of `ludusavi`, may work with latest.
Go to the exact path with cd then download and extract archive to get `ludusavi` binary :
```
cd /home/deck/Documents/bin
wget https://github.com/mtkennerly/ludusavi/releases/download/v0.10.0/ludusavi-v0.10.0-linux.zip
unzip ludusavi-v0.10.0-linux.zip
rm ludusavi-v0.10.0-linux.zip
```
`ludusavi` binary exact location is now `/home/deck/Documents/bin/ludusavi`.
#### This repo
I suggest going to this exact path and clone the repo :
```
# If the path below does not exist, create it first with this command
# mkdir -p /home/deck/Documents/gitrepo
cd /home/deck/Documents/gitrepo
git clone https://github.com/AngeIo/steam-bkuper
cd steam-bkuper
```
Then copy the files to the right location :
```
cp my-steam-backup.sh git-sync /home/deck/Documents/bin/
```
Give execution permission to these files :
```
chmod -R 755 /home/deck/Documents/bin
```
Now we can delete the repo :
```
cd /home/deck/Documents/gitrepo
rm -rf /home/deck/Documents/gitrepo/steam-bkuper
```
### Set up Git repo for backups
Create a new repo on GitLab, GitHub, or both.
In my example, this repo is called `steam-saves`.
Then, if you have multiple remote repos, you can link them to the main one like below if you want to store your backups on multiple locations (configured for 2 repos by default, one named `origin` and the other `origin-new`).
```
git remote add origin-new https://gitlab.com/AngeIo/steam-saves.git
```
/!\ Please use the same branch name as above `origin-new` so it matches with `git-sync` script or you'll need to modify it too.
Check that the git remote repos are correctly setup :
```
git remote -v
```
The output should look like this if done correctly :
```
(deck@asundeck steam-saves)$ git remote -v
origin  https://github.com/AngeIo/steam-saves.git (fetch)
origin  https://github.com/AngeIo/steam-saves.git (push)
origin-new      https://gitlab.com/AngeIo/steam-saves.git (fetch)
origin-new      https://gitlab.com/AngeIo/steam-saves.git (push)
(deck@asundeck steam-saves)$
```
### Apply script to games
Add to each game's "Launch Options" the command below :
#### Backup after game is closed (recommended)
```
%command% ; /home/deck/Documents/bin/my-steam-backup.sh
```
#### Backup while the game is starting
```
/home/deck/Documents/bin/my-steam-backup.sh ; %command%
```
#### Backup while the game is starting and after the game is closed
```
/home/deck/Documents/bin/my-steam-backup.sh ; %command% ; /home/deck/Documents/bin/my-steam-backup.sh
```
### Make sure everything is working
Start a game with Launch Options configured.
Close it.
Check your remote Git repository (GitHub, GitLab, etc.) if the folder `/home/deck/Documents/gitrepo/steam-saves/ludusavi-backup` is populated with your save files then congratulations! You are now safe from any defects your Steam Deck/PC may encounter!
### Final file tree
Here is what your folders should look like in `/home/deck/Documents` :
```
(deck@asundeck Documents)$ tree
.
├── bin
│   ├── git-sync
│   ├── ludusavi
│   └── my-steam-backup.sh
└── gitrepo
    └── steam-saves [Git repo containing your backups]
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
(deck@asundeck Documents)$
```
## Roadmap
- [ ] Use variables/env to modify paths, script names, etc. and prevent users to modify script directly
- [ ] Create an all-in-one script so it's easier to install for users
- [ ] Find a way to loop through all game's Launch Options and add the command automatically
## Contribution
I know this script is far from perfect (school projects takes a lot of my time), that's why you can create pull requests if you wish to improve this script.
Thanks!
## Credits
- Matthew Kennerly and contributors for `ludusavi`
- Simon Thum and contributors for `git-sync`
- Angelo
