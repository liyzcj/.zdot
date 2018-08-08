#!/bin/bash

read -r -p "Are you sure? [y/N]: " res
#case $res in
#	[yY][eE][sS]|[yY])
#		echo yes
#		;;
#	*)
#		echo no
#		;;
#esac

if [[ "$res" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	echo yes
else
	echo no
fi
