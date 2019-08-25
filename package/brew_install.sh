#!/bin/bash

########################################################
# This script will install the packages you specified! #
# System : MacOS
# @author Li Yanzhe, 2019                              #
# ######################################################
source ~/.zdot/lib/echoflags.sh
log=/tmp/install_packages.log

## check function
function check() {
	if [ $? == 0 ]
	then
		ok
	else
		error
		echo "Check '$log'!"
		exit 1
	fi
}

############# PACKAGES #################
packages=(stow cmake tmux macvim python)
############# PACKAGES #################

bot "Now I'm going to install packages for you."

action "Update"
## check the connection to apt repositories

running "Test Hellobrew"

brew --version >> $log 2>&1
check

running "Test connection"
ping -c 1 baidu.com >> $log 2>&1
check

## update the apt 
running "Update apt database"
brew update >> $log 2>&1 
check

action "Install packages"
for pac in ${packages[*]}
do
	running "Installing $COL_CYAN$pac"
	brew install $pac >>$log 2>&1
	check
done

## upgrade all packages
action "Upgrade"
running "List upgradable packages"
brew outdated

bot "Do you want upgrade the packages? [y/n]:"
read res
if [[ "$res" =~ ^([yY][eE][sS]|[yY])+$ ]] || [ ! $res ]
then
	running "Upgrading"
	brew upgrade >>$log 2>&1
	check
fi

## autoremove and clean unuseful packages!
action "Package cleanup"

running "List old packages"
brew outdated

bot "Do you want clean old packages? [y/n]:"
read res
if [[ "$res" =~ ^([yY][eE][sS]|[yY])+$ ]] || [ ! $res ]
then
	running "Upgrading"
	brew cleanup >>$log 2>&1
	check
fi

echo -e "\nlog file : $COL_CYAN$log"
bot "Installation is finished, enjoy!"
