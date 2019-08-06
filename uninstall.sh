#!/bin/bash

source lib/echoflags.sh

## Check parameter #############################

if [[ $1 -ne "zsh" && $1 -ne "bash" ]] || [ ! $1 ]; then
	error "No paramter (zsh|bash)"
	exit 1
fi

bot "Hi, I will uninstall git,$1~"

## uninstall git ################################
bot "Uninstall Others? [y/n]:"
read res
if [[ "$res" =~ ^([yY][eE][sS]|[yY])+$ ]] ; then
	action "Uninstall others"
	running "Remove git link"
	if [ -L ~/.gitconfig ] ; then
		rm ~/.gitconfig
	fi
	check
	running "Remove Octave link"
	if [ -L ~/.octaverc ] ; then
		rm ~/.octaverc
	fi
	check
	running "Restore git from backup"
	if [ -f ~/zdot_backup/.gitconfig ] ; then
		mv ~/zdot_backup/.gitconfig ~
	fi
	check
	running "Restore octave from backup"
	if [ -f ~/zdot_backup/.octaverc ] ; then
		mv ~/zdot_backup/.octaverc ~
	fi
	check
	running "Remove credentials"
	if [ -f ~/.git-credentials ] ; then
		rm ~/.git-credentials
	fi
	check
fi
## uninstall bash or zsh #######################
action "Uninstall $1"
case $1 in 
	bash)
		running "Remove bash link"
		stow -D bash
		check
		running "Restore bash from backup"
		if [ -f ~/zdot_backup/.bashrc ] ; then
			mv ~/zdot_backup/.bashrc ~ 
		fi
		check
		;;
	zsh)
		running "Remove zsh link"
		stow -D zsh
		check
		running "Restore zsh from backup"
		if [ -f ~/zdot_backup/.bashrc ] ; then
			mv ~/zdot_backup/.zshrc ./
		fi
		check
		running "Remove antigen"
		rm -rf ~/.antigen
		check
		if [ -f ~/.zshrc.zwc ] ; then
			running "Remove cache"
			rm -f ~/.zshrc.zwc
			check
		fi
		running "Remove history"
		if [ -f ~/.zsh_history ] ; then
			rm ~/.zsh_history
		fi
		check
		running "change default shell"
		chsh -s /bin/bash
		check
		;;
	*)
		echo "Error! Argument = [bash|zsh]"
		exit 1
		;;
esac

## Remove zdot_backup ###############################
if [ -d ~/zdot_backup ] ; then
	num=`ls -al ~/zdot_backup | wc -l`
	if [ $num == 3 ] ; then
		running "Remove backup directory"
		rm -r ~/zdot_backup
		check
	fi
fi

bot "Uninstall successful!"
