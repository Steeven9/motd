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
	old_folder_name="/etc/update-motd-bkup-$(date +%s)"
	echo "Backing up old files to ${old_folder_name}"
	mkdir $old_folder_name
	mv /etc/update-motd.d/* $old_folder_name

	# Put back default updates and reboot notifications
	cp "${old_folder_name}/90-updates-available" /etc/update-motd.d
	cp "${old_folder_name}/91-release-upgrade" /etc/update-motd.d
	cp "${old_folder_name}/98-reboot-required" /etc/update-motd.d

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

	# Shush default "last login" line for SSH
	cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
	sed -i.bak "s/#PrintLastLog yes/PrintLastLog no/" /etc/ssh/sshd_config
	service ssh restart

	# Clean up downloaded files
	echo "Cleaning up"
	rm -rf motd-master
	echo "Done!"
else
	echo "Installation has been cancelled. Bye!"
fi
