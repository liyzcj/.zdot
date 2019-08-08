#!/bin/bash

source lib/echoflags.sh

## Function ####################################

function remove_restore() {
	running "Remove $1 link"
	if [ -L ~/$1 ] ; then
		rm ~/$1
	fi
	check

	running "Restore $1 from backup"
	if [ -f ~/zdot_backup/$1 ] ; then
		mv ~/zdot_backup/$1 ~
	fi
	check
}

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
	remove_restore ".gitconfig"
	remove_restore ".octaverc"
	remove_restore ".tmux.conf"
	remove_restore ".vimrc"

	running "Remove credentials"
	if [ -f ~/.git-credentials ] ; then
		rm ~/.git-credentials
	fi
	check

	running "Remove .cache"
	if [ -d ~/.cache ] ; then
		rm -rf ~/.cache
	fi
	check

	running "Remove .vim"
	rm -rf ~/.vim
	check

	running "Remove .tmux"
	rm -rf ~/.tmux
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
		running "change default shell"
		chsh -s /bin/bash
		check
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
