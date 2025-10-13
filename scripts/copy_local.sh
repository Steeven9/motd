#!/bin/bash

# Copies all the motd files locally. Useful for testing

# Move old motd files to directory
old_folder_name="/etc/update-motd-bkup-$(date +%s)"
echo "Backing up old files to ${old_folder_name}"
mkdir $old_folder_name
mv /etc/update-motd.d/* $old_folder_name

# Move unzipped motd files to /etc
echo "Installing motd"
cp motd/* /etc/update-motd.d
