#!/bin/bash

#####################################################################################
# This script installs the dotfiles and runs all other system configuration scripts #
# @author Li Yanzhe, 2018.                                                          #
#####################################################################################

## Custmization ####################################################################
ZINUX_DIR=$HOME
LOG=/tmp/zinux_install.log
touch $LOG
BACKUP=1
BACKUP_DIR=$HOME/backup_files
requirement=(
git
vim
)
## options #########################################################################
TEMP=`getopt -o t:n --long target:,nobackup -- "$@"`
if [ $? != 0 ] ; then echo "Options error..." >&2 ; exit 1 ; fi
eval set -- "$TEMP"
while true ; do
	case "$1" in
		-t | --target) ZINUX_DIR=$2 ; shift 2 ;;
		-n | --nobackup) BACKUP=0 ; shift ;;
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done
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
	echo -e "\t$COL_RED[error]$COL_RESET "Failed!
}

check_success() {
	if [ $? == 0 ]
	then
		ok
	else
		error
		echo "See '/tmp/zinux_install.log'!"
		exit 1
	fi
}



bot "Hi! I'm going to install tooling and tweak your system settings. Here I go..."

## Install required packages ########################################################
action "Installing required packages"
for pac in ${requirement[@]}
do
	running "Installing $COL_CYAN$pac"
	sudo apt-get -y install $pac >/dev/null 2>>$LOG
	check_success
done

## clone dotfiles repo from github #################################################

cd $ZINUX_DIR
action "Cloning repo from github"
running "Cloning ${COL_CYAN}zinux$COL_RESET into $ZINUX_DIR "
echo -e "\n\t\t"
git clone --recurse-submodules https://github.com/liyzcj/zinux.git >/dev/null 2>>$LOG
check_success
ZINUX_DIR=$ZINUX_DIR/zinux
## Backup ####### ##################################################################
if [ $BACKUP == 1 ] 
then
# creat backup folder
	action "Backup files"
	if [ ! -d $BACKUP_DIR ] 
	then
		mkdir $BACKUP_DIR
	fi
else
	action "Delete files"
fi
# backup >>>>>.bashrc
if [ -f $HOME/.zshrc ] 
then
	if [ $BACKUP == 1 ] 
	then
		running "Backup ${COL_CYAN}.bashrc"
		mv $HOME/.bashrc $BACKUP_DIR/bashrc >>$LOG
		check_success
	else
		running "Delete ${COL_CYAN}.bashrc"
		rm $HOME/.bashrc >>$LOG
		check_success
	fi
fi
# backup >>>>>.gitconfig
if [ -f $HOME/.gitconfig ] 
then
	if [ $BACKUP == 1 ] 
	then
		running "Backup ${COL_CYAN}.gitconfig"
		mv $HOME/.gitconfig $BACKUP_DIR/gitconfig >>$LOG
		check_success
	else
		running "Delete ${COL_CYAN}.gitconfig"
		rm $HOME/.gitconfig >>$LOG
		check_success
	fi
fi
## Make soft link ##################################################################
action "Making soft links" 
# >>>>>>>>>>  .bashrc
running "Linking ${COL_CYAN}.bashrc"
echo "[ -n \"\$PS1\" ] && source $ZINUX_DIR/bash/bash_profile;" > ~/.bashrc
check_success
# >>>>>>>>>>  .gitconfig
running "Linking ${COL_CYAN}.gitconfig"
ln -s $ZINUX_DIR/git/gitconfig $HOME/.gitconfig >>$LOG
check_success

bot "Installation is finished, enjoy!"
rm $LOG
bash
