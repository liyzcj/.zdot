source /home/alex/zinux/lib_sh/echoflags.sh
for package in $(sed 's/#.*//' /home/alex/requirement)
do
	action "Installing $package"
	sudo apt-get -y install ${package}  >/dev/null 2>&1
	if [ $? == 0 ]
	then
		ok "Successful!"
	else
		error "Failed!"
	fi
done
