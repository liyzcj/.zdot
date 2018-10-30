#!/bin/bash

##################################################
# Usage: install [zsh|bash]                      #
# This script will link the dotfiles.            #
# @author Li Yanzhe, 2018.                       #
##################################################
backup=~/zdot_backup
source lib/echoflags.sh

bot "Hi! I will install packages,git,$1 for you!"

if [ ! -d $backup ] ; then
	mkdir $backup
fi
action "Install $1"

## install pakcages ##############################
bot "Install packages? [y/n]:"
read res
if [[ "$res" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	if grep -Eqi "arch" /etc/issue || grep -Eqi "arch" /etc/*-release; then
		package/pac_install.sh
	elif grep -Eqi "ubuntu" /etc/issue || grep -Eqi "ubuntu" /etc/*-release; then
		package/apt_install.sh
	else
		echo "Unknown Release!"
	fi
fi

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
		running "Change Default shell"
		chsh -s /bin/zsh
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
bot "Install Others:Git Octave? [y/n]:"
read res
if [[ "$res" =~ ^([yY][eE][sS]|[yY])+$ ]] ; then
	action "Install Others"
	running "Backup .gitconfig"
	if [ -f ~/.gitconfig ] ; then
		mv ~/.gitconfig $backup
	fi
	check
	running "Backup .octaverc"
	if [ -f ~/.octaverc ] ; then
		mv ~/.octaverc $backup
	fi
	check
	running "Install others"
	stow others
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
