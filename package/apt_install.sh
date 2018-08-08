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
sourcelist=$(grep -ohr -E "https?://[a-zA-Z0-9\.\/_&=@$%?~#-]*" /etc/apt/sources.list | awk 'NR==1{print}')
echo ">>>>>>>> source list = $sourcelist" >> $log
running "Test connection"
ping -c $sourcelist >> $log 2>&1
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
