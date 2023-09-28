#!/bin/sh

# install script for Ubuntu (Mate 22.04)
# set environment variables
export ROOT=/
export HOME=${ROOT}home/$(whoami)
export DROPBOX=/mnt/d/Dropbox
cd ~/

# update system
sudo apt update
sudo apt full-upgrade

# fix snapd issues
# Getting snapd to work: https://github.com/microsoft/WSL/issues/5126
sudo apt-get install -yqq daemonize dbus-user-session fontconfig  
sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target  
exec sudo nsenter -t $(pidof systemd) -a su - $LOGNAME

# install core dependency
# BEFORE INSTALLING: add /mnt to PRUNEPATHS in /etc/updatedb.conf, otherwise plocate may take ETERNITY to complete
sudo apt install git curl plocate build-essential gcc font-manager xclip nautilus
sudo snap install ruby --classic --channel=2.6/stable # for installing brew
sudo snap install emacs --classic
# install common applications
sudo snap install 1password postman

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# if brew not found
export BREW=$(brew --prefix)
# tap 3rd party packages
brew update
brew install git zsh wget curl gpg z ripgrep ag w3m pandoc
touch $HOME/.z
# install brew development environment
brew install pyenv nvm postgresql@15 redis # SELECT version of PostgreSQL here
# install rvm
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
rvm pkg install openssl
rvm install --latest --with-openssl-dir=`brew --prefix openssl` # SELECT version of Ruby here, as alternative to brew's OpenSSL, you may use RVM's one, $HOME/.rvm/usr
# install tabby
curl -s https://packagecloud.io/install/repositories/eugeny/tabby/script.deb.sh | sudo bash
sudo apt install tabby-terminal
# https://github.com/Eugeny/tabby/releases/download/v1.0.200/tabby-1.0.200-linux-x64.deb # SELECT version of Tabby here
# sudo dpkg -i tabby-1.0.200-linux-x64.deb

# install emacs file & system configuration files
git clone https://github.com/asdingfs/macosx-emacs-init.git .emacs.d/
# link org notes synced to dropbox
ln -s ${DROPBOX}/Org ${HOME}/.emacs.d/.personal.d/org
# link org-roam synced to dropbox
ln -s ${HOME}/.emacs.d/.personal.d/org/notes/brain/org-roam ${DROPBOX}/Brain/org-roam
ln -s ${DROPBOX}/Brain/logseq-brain/ $HOME/.emacs.d/.personal.d/org/notes/brain/
# populate submodules
cd .emacs.d/
git submodule update --init
cd ../
# copy the emacs.service to start server on startup
# following this guide: https://simpleit.rocks/linux/ubuntu/start-emacs-in-ubuntu-the-right-way/
mkdir -p ${HOME}/.config/systemd/user
cp /snap/emacs/current/usr/lib/systemd/user/emacs.service ~/.config/systemd/user/
# copy fonts for emacs, copy from Dropbox to ~/.fonts
mkdir -p ~/.fonts
find ${DROPBOX}/Configurations/fonts -name \*.otf -exec cp {} ~/.fonts/ \;
find ${DROPBOX}/Configurations/fonts -name \*.ttc -exec cp {} ~/.fonts/ \;
fc-cache -f -v

# start emacs service
systemctl --user enable emacs.service
systemctl --user start emacs.service

# setup SSH keys
# setting up ssh keys, recommended to store keys inside ~/.ssh/keys
mkdir -p $HOME/.ssh/keys
echo "Setting up ssh keys for GitHub access..."
ssh-keygen -t rsa -C "github:anthonysetiawan.ding@gmail.com" -b 4096
echo "Setting up ssh keys for GitLab access..."
ssh-keygen -t rsa -C "gitlab:anthonysetiawan.ding@gmail.com" -b 4096
# setting up ssh keys for SMRT
ssh-keygen -t rsa -C "codecommit:anthonysetiawan@smrt.com.sg" -b 4096
chmod -R 400 ~/.ssh/keys/*
# add private keys to OpenSSL
ln -s $HOME/.config/personal/ubuntu/ssh/ssh-agent.service $HOME/.config/systemd/user/ssh-agent.service
# find ~/.ssh/keys/* \! -name "*.pub" -exec ssh-add {} +
ln -s $HOME/.config/personal/ubuntu/ssh/ssh_config $HOME/.ssh/config

# soft-link system config files
# all .zlogin, .zshenv, .zshrc are set to be load from $ZDOTDIR
# they can be found in $HOME/.config/personal/ubuntu/zsh directory
# https://scriptingosx.com/2019/06/moving-to-zsh-part-2-configuration-files/ for more info
cp $HOME/.config/personal/ubuntu/zsh/home.zshenv $HOME/.zshenv # sets ZDOTDIR in $HOME/.zshenv, according to: https://www.reddit.com/r/zsh/comments/3ubrdr/proper_way_to_set_zdotdir/
. $HOME/.zshenv # load the env variable
chmod -R 755 $BREW/share/zsh

# setup git username & email
git config --global user.name "Anthony Setiawan"
git config --global user.email "anthonysetiawan.ding@gmail.com"

# install numix themes
sudo add-apt-repository ppa:numix/ppa
sudo apt-get update
sudo apt-get install numix-gtk-theme numix-icon-theme-circle

# you can run Windows VirtualBox VM
# by following this link https://www.learnitguide.net/2023/04/can-i-run-windows-vm-on-ubuntu.html

# disable some unused keyboard shortcuts in ubuntu
gsettings set org.freedesktop.ibus.panel.emoji hotkey "[]"

# install custom scripts:
mkdir -p ~/.local/bin

# install screenshot script for taking screenshots of an area in ubuntu-mate
ln -s ${HOME}/.config/personal/ubuntu/scripts/screenshot ~/.local/bin
chmod 755 ~/.local/bin/screenshot

# install focus_ec script for creating emacsclient frame when non-existent, or raise frame
ln -s ${HOME}/.config/personal/ubuntu/scripts/focus_ec ~/.local/bin
chmod 755 ~/.local/bin/focus_ec

