#!/bin/zsh

# install script for MacOSX Catalina

# install xcode command line tools
xcode-select --install

# set environment variables
export ROOT=/System/Volumes/Data
export HOME=${ROOT}/Users/$(whoami)
cd ~/

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# tap 3rd party packages
brew update
brew tap homebrew/cask-fonts

# install brew zsh version
brew install zsh

# restarts zsh to use the brew version
exec zsh

# note in MacOSX CATALINA, you need to grant full disk access to the terminal app that you're running

# packages to install in this script
BREW_PACKAGES=(wget curl gpg z ripgrep ag w3m pandoc git python postgres redis node kubernetes-cli kubectx imagemagick@6 svn)
# TODO: additional brew packages: texinfo
CASK_PACKAGES=(1password paragon-ntfs omnidisksweeper onyx appcleaner emacs iterm2 karabiner-elements shiftit scroll-reverser font-inconsolata font-latin-modern-math fluid dropbox google-drive firefox franz telegram skype discord zoom flume tunnelblick spotify dash postman docker android-file-transfer android-studio vysor google-chrome blender figma sketch gimp inkscape handbrake mediahuman-audio-converter mediahuman-youtube-downloader musicbrainz-picard pdf-expert musescore sequential send-to-kindle calibre flux vlc swinsian elmedia-player reflector duet parsec jump-desktop-connect steam openemu transmission alfred)
# TODO: additional cask packages: mactex
PIP_PACKAGES=(awscli)

# apps to install manually:
# 1. Use Fluid to build native app out of web pages:
#     - Asana
# 2. Download from AppStore:
#     - Snap (shortcuts)
#     - Magnet (like ShiftIt)
#     - Monity: https://monityapp.com/ (MacOSX Status Monitoring)
#     - Battery Monitor: Health, Info (Battery Health & Display)
#     - Clocker (timezone)
#     - JIRA Cloud App
#     - Relax Melodies Premium
#     - Typesy/Typist
#.    - Spark
# 3. Manually download & install from websites:
#     - Affinity Photo
#     - Affinity Designer
#     - Capture One
#     - Google Drive
#     - Palette Master Element (BENQ Monitor hardware calibration)
#     - TeamViewer
#     - Discord
# 4. Install later on brew/cask if needed:
#     - visit: https://formulae.brew.sh/cask/ for full list of casks
#     - brew install texinfo/brew cask install mactex

# install packages
alias pip=pip3
brew install "${BREW_PACKAGES[@]}"
brew install --cask "${CASK_PACKAGES[@]}"
pip install "${PIP_PACKAGES[@]}"

# force link some weird packages
brew link --force imagemagick@6

# install emacs file & system configuration files
git clone https://github.com/asdingfs/macosx-emacs-init.git .emacs.d/
# populate submodules
cd .emacs.d/
git submodule update --init
cd ../

# setting up ssh keys, recommended to store keys inside ~/.ssh/keys
mkdir -p $HOME/.ssh/keys
echo "Setting up ssh keys for GitHub access..."
ssh-keygen -t rsa -C "github:anthonysetiawan.ding@gmail.com" -b 4096
echo "Setting up ssh keys for GitLab access..."
ssh-keygen -t rsa -C "gitlab:anthonysetiawan.ding@gmail.com" -b 4096
echo "Setting up ssh keys for SMRT's CodeCommit access..."
ssh-keygen -t rsa -C "codecommit:anthonysetiawan@smrt.com.sg" -b 4096

# change permission of key file
chmod -R 400 ~/.ssh/keys/

# to add to keychain
find ~/.ssh/keys/* \! -name "*.pub" -exec ssh-add -K {} +

# soft-link system config files
# all .zlogin, .zshenv, .zshrc are set to be load from $ZDOTDIR
# they can be found in $HOME/.config/personal/macosx/zsh directory
# https://scriptingosx.com/2019/06/moving-to-zsh-part-2-configuration-files/ for more info
cp $HOME/.config/personal/zsh/home.zshenv $HOME/.zshenv # sets ZDOTDIR in $HOME/.zshenv, according to: https://www.reddit.com/r/zsh/comments/3ubrdr/proper_way_to_set_zdotdir/
. $HOME/.zshenv # load the env variable

chmod -R 755 $ROOT/usr/local/share/zsh

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# setup emacs scripts
ln -s $HOME/.config/personal/macosx/emacs/es $ROOT/usr/local/bin
ln -s $HOME/.config/personal/macosx/emacs/ec $ROOT/usr/local/bin
ln -s $HOME/.config/personal/macosx/emacs/em $ROOT/usr/local/bin
chmod 755 $HOME/.config/personal/macosx/emacs/es $HOME/.config/personal/macosx/emacs/ec $HOME/.config/personal/macosx/emacs/em

# fix emacs compatibility with MacOSX Catalina, https://spin.atomicobject.com/2019/12/12/fixing-emacs-macos-catalina/
# also on: https://medium.com/@holzman.simon/emacs-on-macos-catalina-10-15-in-2019-79ff713c1ccc
# remember to grant Full Disk Access to Emacs
# ALSO: remember to grant Full Disk Access to /usr/bin/ruby too (see: https://apple.stackexchange.com/questions/371888/restore-access-to-file-system-for-emacs-on-macos-catalina)
cd $ROOT/Applications/Emacs.app/Contents/MacOS
mv Emacs Emacs-launcher # for backup
cp Emacs-x86_64-10_14 Emacs
cd /Applications/Emacs.app/Contents/
rm -rf _CodeSignature
cd ~/

# link org-roam to logseq
ln -s $HOME/Dropbox/Brain/logseq-brain/ $HOME/.emacs.d/.personal.d/org/notes/brain/

# setup discord shell script as workaround in Hackintosh
ln -s $HOME/.config/personal/macosx/discord/discord $ROOT/usr/local/bin
chmod 755 $HOME/.config/personal/macosx/discord/discord

# link launchd to start emacs at startupN
chmod 755 $HOME/.config/personal/macosx/emacs/gnu.emacs.daemon.LaunchAtLogin.agent.plist
mkdir -p $HOME/Library/LaunchAgents
ln -s $HOME/.config/personal/macosx/emacs/gnu.emacs.daemon.LaunchAtLogin.agent.plist $HOME/Library/LaunchAgents
launchctl load -w $HOME/Library/LaunchAgents/gnu.emacs.daemon.LaunchAtLogin.agent.plist

# setup karabiner & ssh config
ln -s $HOME/.config/personal/macosx/ssh_config $HOME/.ssh/config
mkdir -p .config
ln -s $HOME/.config/personal/macosx/karabiner_config $HOME/.config/karabiner

# setup git username & email
git config --global user.name "Anthony Setiawan"
git config --global user.email "anthonysetiawan.ding@gmail.com"

# setup themes
open $HOME/.config/personal/macosx/Tomorrow\ Night\ Eighties.itermcolors

# install kubernetes
echo "Setting up kubernetes..."
aws configure
curl https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/darwin/amd64/aws-iam-authenticator -o aws-iam-authenticator
cp aws-iam-authenticator $ROOT/usr/local/bin
# aws eks update-kubeconfig --name eks-dev-cluster
aws eks update-kubeconfig --name eks-prod-cluster

# run at startup
brew services start postgresql
brew services start redis

# install rvm & ruby
gpg --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
rvm pkg install openssl
rvm install ruby --latest --with-openssl-dir=$HOME/.rvm/usr

# other customisations for MacOS
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 70 '<dict><key>enabled</key><false/></dict>' # disable CMD+CTRL+D
defaults write com.apple.notificationcenterui bannerTime -int 2 # shorten notification banner time to 2s
