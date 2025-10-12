#!/bin/bash
clear
echo "Hi! This script will install custom MOTD"
read -p "Continue? [Y/n] " -r REPLY
if [[ $REPLY =~ ^[Yy]$ ]]; then
	source /etc/os-release
	echo "Detected OS: $PRETTY_NAME"

	# Install packages
	echo "Installing utilities (this may take a while):"
	echo -n "    - updating repos....."
	apt-get update
	echo "done"
	echo -n "    - installing toilet............."
	apt-get install toilet -y
	echo "done"
	echo -n "    - installing colorized-logs....."
	apt-get install colorized-logs -y
	echo "done"
	echo "Utilities installed successfully"

	# Download the archive
	echo "Downloading motd"
	curl -L https://github.com/Steeven9/motd/archive/master.tar.gz | tar -zxv

	# Move old motd files to directory
	echo "Backing up old motd to /etc/update-motd.d/old-motd"
	mkdir /etc/update-motd.d/old-motd
	mv /etc/update-motd.d/* /etc/update-motd.d/old-motd

	# Move unzipped motd files to /etc
	echo "Installing motd"
	mv motd-master/motd/* /etc/update-motd.d
	if [[ $PRETTY_NAME == "Debian" ]]; then
		rm -f /etc/motd
		ln -sf /var/run/motd /etc/motd
	fi
	echo "Setting permissions"
	chmod +x /etc/update-motd.d/*

	# Clean up downloaded files
	echo "Cleaning up"
	rm -rf motd-master
	echo "Done!"
else
	echo "Installation has been cancelled. Bye!"
fi
