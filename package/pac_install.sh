#!/bin/bash

########################################################
# This script will install the packages you specified! #
# System : Arch Linux				       #
# @author Li Yanzhe, 2018                              #
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


bot "Now I'm going to install packages for you."

action "Update"
## check the connection to pacman repository
running "Test connection"
ping -c 1 google.com >> $log 2>&1
check

## update the apt 
running "Update apt database"
sudo pacman -Fy >> $log 2>&1 
check
action "Install packages"
for pac in $(sed 's/#.*//' ~/.zdot/package/package.list)
do
	running "Installing $COL_CYAN$pac"
	sudo pacman -S --noconfirm $pac >> $log 2>&1
	check
done

## upgrade all packages
action "Upgrade"
running "Upgrading"
sudo pacman -Syu
check

## autoremove and clean unuseful packages!
action "Package cleanup"
running "Cleaning Cache"
sudo pacman -Scc
check

echo -e "\nlog file : $COL_CYAN$log"
bot "Installation is finished, enjoy!"
