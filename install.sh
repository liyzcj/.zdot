#!/bin/bash

#####################################################################################
# This script installs the dotfiles and runs all other system configuration scripts #
# @author Li Yanzhe, 2018.                                                          #
#####################################################################################

## Custmization ####################################################################
ZINUX_DIR=$HOME/zinux
BACKUP_DIR=$HOME/backup_files
requirement=(
git
zsh
)
## echo colors and function ########################################################
# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

function ok() {
	echo -e "\t\t\t$COL_GREEN[ok]$COL_RESET "Successful!
}

function bot() {
	echo -e "\n$COL_GREEN\[._.]/$COL_RESET - "$1
}

function running() {
	echo -en "$COL_YELLOW ⇒ $COL_RESET"$1": "
}

function action() {
	echo -e "\n$COL_YELLOW[action]:$COL_RESET\n ⇒ $1..."
}

function error() {
	echo -e "$COL_RED[error]$COL_RESET "Failed!
}

check_success() {
	if [ $? == 0 ]
	then
		ok
	else
		error
	fi
}



bot "Hi! I'm going to install tooling and tweak your system settings. Here I go..."

## Install required packages ########################################################
action "Installing required packages"
for pac in ${requirement[@]}
do
	running "Installing $COL_CYAN$pac"
	sudo apt-get -y install $pac >/dev/null 2>&1
	check_success
done

## clone dotfiles repo from github #################################################

cd $HOME
action "Cloning repo from github"
running "Cloning ${COL_CYAN}zinux"
git clone --recurse-submodules https://github.com/liyzcj/zinux.git >/dev/null 2>&1
check_success

## Make soft link ##################################################################
action "Making soft links"
# creat backup folder
if [ ! -d $BACKUP_DIR ]
then
	mkdir $BACKUP_DIR
fi
# >>>>>>>>>>  .zshrc
if [ -f $HOME/.zshrc ]
then
	mv $HOME/.zshrc $BACKUP_DIR/zshrc
fi
running "Linking ${COL_CYAN}.zshrc"
ln -s $ZINUX_DIR/zsh/zshrc_antigen $HOME/.zshrc
check_success
# >>>>>>>>>>  .gitconfig
if [ -f $HOME/.gitconfig ]
then
	mv $HOME/.gitconfig $BACKUP_DIR/gitconfig
fi
running "Linking ${COL_CYAN}.gitconfig"
ln -s $ZINUX_DIR/git/gitconfig $HOME/.gitconfig
check_success
