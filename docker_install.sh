#!/usr/bin/env bash

##################################################
# Usage: docker_install [zsh|bash]                      #
# This script will link the dotfiles.            #
# @author Li Yanzhe, 2019.                       #
##################################################
ZDOT_ROOT=$HOME/.zdot
backup=~/zdot_backup
source $ZDOT_ROOT/lib/echoflags.sh

bot "Starting Install .zdot"

if [ ! -d $backup ] ; then
	mkdir $backup
fi
action "Install zsh"

## function ######################################

function backup() {
	running "Backup $1"
	if [ -f ~/$1 ] ; then
		mv ~/$1 $backup
	fi
	check
}


## Check submodule antigen #######################

if [ ! -f ~/.zdot/zsh/antigen/antigen.zsh ] ; then
	warn "Antigen not detected!"
	running "Updating antigen"
	git submodule init
	git submodule update --remote
	check
fi

## Install or zsh ###########################
running "Change Default shell"
chsh -s /bin/zsh
check
running "Backup .zshrc"
if [ -f ~/.zshrc ] ; then
	mv ~/.zshrc $backup
fi
check
running "Stow zsh"
stow --ignore=antigen -d $ZDOT_ROOT -t $HOME zsh
check
running "Install plugins\n"
zsh -i -c exit
check


## install others ##################################
action "Install Others"
backup ".gitconfig"
backup ".octaverc"
backup ".tmux.conf"
backup ".vimrc"

running "Install others"
stow -d $ZDOT_ROOT -t $HOME others
check

## install vundle for vim ###########################

running "Install vundle for vim"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
check
running "Install plugins for vim"
vim +PluginInstall +qall
check
running "Compile YCM"
python3 ~/.vim/bundle/YouCompleteMe/install.py
check
running "Install tpm for tmux"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
check
running "Install plugins for tmux"
~/.tmux/plugins/tpm/scripts/install_plugins.sh
check

## Remove zdot_backup ###############################

if [ -d ~/zdot_backup ] ; then
	num=`ls -al ~/zdot_backup | wc -l`
	if [ $num == 3 ] ; then
		running "Remove backup directory"
		rm -r ~/zdot_backup
		check
	fi
fi

bot "Install successful!"
