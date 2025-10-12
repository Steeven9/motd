#!/bin/bash

echo "Hi! This script will install custom MOTD."
echo "Make sure you run this as sudo!"
read -p "Continue? [Y/n] " -r REPLY

if [[ $REPLY =~ ^[Yy]$ ]]; then
	source /etc/os-release
	echo "Detected OS: $PRETTY_NAME"

	# Install packages
	echo "Installing utilities (this may take a while):"
	echo -n "    - updating repos....."
	apt-get update
	echo "done"
	echo -n "    - installing packages............."
	apt-get install toilet colorized-logs -y
	echo "done"

	# Download the archive
	echo "Downloading motd"
	curl -L https://github.com/Steeven9/motd/archive/master.tar.gz | tar -zxv

	# Move old motd files to directory
	old_folder_name="/etc/update-motd.d/old-motd-$(date +%s)"
	echo "Backing up old files to ${old_folder_name}"
	mkdir $old_folder_name
	mv /etc/update-motd.d/* $old_folder_name

	# Move unzipped motd files to /etc
	echo "Installing motd"
	mv motd-master/motd/* /etc/update-motd.d
	if [[ $PRETTY_NAME == "Debian" ]]; then
		echo "Extra steps for Debian"
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
