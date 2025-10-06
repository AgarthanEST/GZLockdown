#!/bin/bash

# NOTE: Check that you are the root account? This tool should be used on a fresh install. Check file location too + OS Version
# Minimise attack surface with minimal software installs. Limit permissions
# Do a Y/N on if this is a fresh server on root?

## Unattended Security Updates

apt-get update && apt-get upgrade -y && apt install unattended-upgrades -y && \
sed -i 's/APT::Periodic::Unattended-Upgrade "0";/APT::Periodic::Unattended-Upgrade "1";/g' /etc/apt/apt.conf.d/20auto-upgrades && \
clear

# ^^ Verify the above actually makes UA update. Perhaps reboot is required.

## Create Non-Root Sudo User

read -p "New Username: " desired_user && adduser $desired_user && usermod -aG sudo $desired_user && \
echo "$desired_user ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$desired_user && \
cp newuser.sh /home/$desired_user/ && chown $desired_user:$desired_user /home/$desired_user/newuser.sh && \
su - $desired_user -c "bash ~/newuser.sh"

# NOTE: Auto clean at the end! Ensure that the script is in ~/
