#!/bin/bash

##################################################
# Usage: install [zsh|bash]                      #
# This script will link the dotfiles.            #
# @author Li Yanzhe, 2018.                       #
##################################################
backup=~/zdot_backup
source lib/echoflags.sh

if [[ $1 -ne "zsh" && $1 -ne "bash" ]] || [ ! $1 ] ; then
	error "Need parameter (zsh|bash)"
	exit 1
fi

bot "Hi! I will install packages,git,$1 for you!"

if [ ! -d $backup ] ; then
	mkdir $backup
fi
action "Install $1"

## function ######################################

function backup() {
	running "Backup $1"
	if [ -f ~/$1 ] ; then
		mv ~/$1 $backup
	fi
	check
}


## install antigen #######################

git clone https://github.com/zsh-users/antigen.git $HOME/.antigen/antigen
check

## install pakcages ##############################
bot "Install packages? [y/n]:"
read res
if [[ "$res" =~ ^([yY][eE][sS]|[yY])+$ ]] || [ ! $res ]
then
	if grep -Eqi "arch" /etc/issue || grep -Eqi "arch" /etc/*-release; then
		package/pac_install.sh
	elif grep -Eqi "ubuntu" /etc/issue || grep -Eqi "ubuntu" /etc/*-release; then
		package/apt_install.sh
	elif grep -Eqi "debian" /etc/issue || grep -Eqi "debian" /etc/*-release; then
		package/apt_install.sh
	elif [ `uname -s` == "Darwin" ]; then
		package/brew_install.sh
	else
		error "Unknown Release version!"
		exit 1
	fi
fi

## Install bash or zsh ###########################
case $1 in
	zsh)
		running "Change Default shell"
		chsh -s /bin/zsh
		check
		running "Backup .zshrc"
		if [ -f ~/.zshrc ] ; then
			mv ~/.zshrc $backup
		fi
		check
		running "Stow zsh"
		stow --ignore=antigen zsh
		check
		running "Install plugins\n"
		zsh -i -c exit
		check
		;;
	bash)
		running "Backup .bashrc"
		if [ -f ~/.bashrc ] ; then
			mv ~/.bashrc $backup
		fi
		check
		running "Stow bash"	
		stow bash
		check
		;;
	*)
		echo "Error! Argument = [bash|zsh]"
		exit 1
		;;
esac


## install others ##################################
bot "Install Others:Git Octave vim tmux? [y/n]:"
read res
if [[ "$res" =~ ^([yY][eE][sS]|[yY])+$ ]] || [ ! $res ] ; then
	action "Install Others"
	backup ".gitconfig"
	backup ".octaverc"
	backup ".tmux.conf"
	backup ".vimrc"

	running "Install others"
	stow others
	check
fi

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
