#!/bin/bash

#####################################################################################
# This script installs the dotfiles and runs all other system configuration scripts #
# @author Li Yanzhe, 2018.                                                          #
#####################################################################################

ZINUX_DIR=$HOME/zinux
BACKUP_DIR=$HOME/backup_files
source ./lib_sh/echoflags.sh

bot "Hi! I'm going to install tooling and tweak your system settings. Here I go..."

check_success() {
	if [ $? == 0 ]
	then
		ok "Successful!"
	else
		error "Failed!"
	fi
}
## Install required packages ########################################################
action "Installing required packages"
for pac in $(sed 's/#.*//' ./requirement)
do
	running "Installing $COL_CYAN$pac"
	sudo apt-get -y install $pac >/dev/null 2>&1
	check_success
done

# clone dotfiles repo from github
cd $HOME
git clone --recurse-submodules https://github.com/liyzcj/zinux.git

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
