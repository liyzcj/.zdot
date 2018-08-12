#!/bin/bash

##################################################
# Usage: install [zsh|bash]                      #
# This script will link the dotfiles.            #
# @author Li Yanzhe, 2018.                       #
##################################################
backup=~/zdot_backup

source lib/echoflags.sh
## check function

function check() {
	if [ $? == 0 ] ; then
		ok
	else
		error
		exit 1
	fi
}

bot "Hi! I will install packages,git,$1 for you!"

if [ ! -d $backup ] ; then
	mkdir $backup
fi
action "Install $1"
## Install bash or zsh ###########################
case $1 in
	zsh)
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
		running "Replace pure"
		cp ~/.zdot/lib/pure.zsh ~/.antigen/bundles/sindresorhus/pure
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
## install pakcages ##############################
bot "Install packages? [y/n]:"
read res
if [[ "$res" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	package/apt_install.sh
fi

## install git ##################################
bot "Install Git? [y/n]:"
read res
if [[ "$res" =~ ^([yY][eE][sS]|[yY])+$ ]] ; then
	action "Install git"
	running "Backup .gitconfig"
	if [ -f ~/.gitconfig ] ; then
		mv ~/.gitconfig $backup
	fi
	check
	running "Install git"
	stow git
	check
fi

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
