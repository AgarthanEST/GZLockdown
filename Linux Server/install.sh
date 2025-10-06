#!/bin/bash

# NOTE: Check that you are the root account? This tool should be used on a fresh install. Check file location too + OS Version
# Minimise attack surface with minimal software installs. Limit permissions
# Do a Y/N on if this is a fresh server on root?

## Customisation Variables
clear

while true; do
  read -p "New Username: " desired_user
  if [[ -n "$desired_user" ]]; then
    break
  else
    echo "Username cannot be empty. Please try again."
  fi
done


while true; do
  read -s -p "Enter password: " Password
  echo
  read -s -p "Retype password: " Password2
  echo
  if [ "$Password" == "$Password2" ]; then
    echo "Passwords match."
    break
  else
    echo "Passwords do not match. Please try again."
  fi
done

## Unattended Security Updates
set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y
apt-get install -y unattended-upgrades

cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF

echo "unattended-upgrades unattended-upgrades/enable_auto_updates boolean true" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -f noninteractive unattended-upgrades

## Prepare cleanup.sh
cp cleanup.sh /home/$desired_user/
chown $desired_user:$desired_user /home/$desired_user/cleanup.sh

## Create Non-Root Sudo User
adduser --disabled-password --gecos ",,," "$desired_user"
echo "$desired_user:$Password" | chpasswd

#adduser $desired_user

usermod -aG sudo $desired_user && \
echo "$desired_user ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$desired_user && \
cp newuser.sh /home/$desired_user/ && chown $desired_user:$desired_user /home/$desired_user/newuser.sh && \
su - $desired_user -c "bash ~/newuser.sh"
