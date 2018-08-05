#!/bin/bash

TEMP=`getopt -o ab:c:: --long a-long,b-long:,c-long:: -- "$@"`
echo $TEMP
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
eval set -- "$TEMP"
echo $1
echo $2
echo $3
echo $4
echo $5
echo $6
echo $7
while true ; do
	case "$1" in
		-a | --a-long) echo "Option a" ; shift ;;
		-b | --b-long) echo "Option b, argument $2" ; shift 2 ;;
		-c | --c-long)
			case "$2" in
				"") echo "Option c, no argument"; shift 2 ;;
				*) echo "Option c, argument $2" ; shift 2 ;;
			esac ;;
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done
echo "Remaining arguments:"
for arg do
	echo '-->'"$arg"
done
