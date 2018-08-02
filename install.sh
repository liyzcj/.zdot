#!/bin/bash

#####################################################################################
# This script installs the dotfiles and runs all other system configuration scripts #
# @author Li Yanzhe, 2018.                                                          #
#####################################################################################

source ./lib_sh/echoflags.sh

bot "Hi! I'm going to install tooling and tweak your system settings. Here I go..."

## Install required packages ########################################################
action "Installing required packages"
for pac in $(sed 's/#.*//' ./requirement)
do
	running "Installing $COL_CYAN$pac"
	sudo apt-get -y install $pac >/dev/null 2>&1
	if [ $? == 0 ]
	then
		ok "Successful!"
	else
		error "Failed!"
	fi
done
