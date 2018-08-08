#!/bin/bash

########################################################
# This script will install the packages you specified! #
# System : Debian, Ubuntu...
# @author Li Yanzhe, 2018                              #
# ######################################################
source ../lib/echoflags.sh
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


bot "Hi! I'm going to install packages for you. Here I go..."

action "Update"
## check the connection to apt repositories
running "Test connection"
ping -c 1 google.com >> $log 2>&1
check

## update the apt 
running "Update apt database"
sudo apt-get update >> $log 2>&1 
check

action "Install packages"
for pac in $(sed 's/#.*//' ./package.list)
do
	running "Installing $COL_CYAN$pac"
	sudo apt-get -y install $pac >>$log 2>&1
	check
done

## upgrade all packages
action "Upgrade"
running "List upgradable packages"
sudo apt list --upgradable
bot "Do you want upgrade the packages?"
read -p "[y/n]?: " res
if [[ "$res" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	running "Upgrading"
	sudo apt -y upgrade >>$log 2>&1
	check
fi

## autoremove and clean unuseful packages!
action "Package cleanup"
running "Autoremove"
sudo apt -y autoremove >>$log 2>&1
check

running "Autoclean"
sudo apt -y autoclean >>$log 2>&1
check

echo -e "\nlog file : $COL_CYAN$log"
bot "Installation is finished, enjoy!"
