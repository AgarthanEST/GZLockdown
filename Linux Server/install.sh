#!/bin/bash

# NOTE: Check that you are the root account? This tool should be used on a fresh install. Check file location too + OS Version
# Minimise attack surface with minimal software installs. Limit permissions
# Do a Y/N on if this is a fresh server on root?

## Functions
function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) return  1 ;;
        esac
    done
}

## Customisation Variables
clear
echo "*************************"
echo "AUTO SERVER HARDENING"
echo "*************************"
echo

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
    echo
    break
  else
    echo "Passwords do not match. Please try again."
  fi
done

bonus_features=false
cleanup=false
yes_or_no "Do you want bonus optional security features? (RECOMMENDED, REQUIRES INTERACTION)" && bonus_features=true
yes_or_no "Do you want script files to be cleaned post run?" && cleanup=true
echo

## Unattended Security Updates
set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y
apt-get install -y unattended-upgrades

cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";  ## 1 day
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF

echo "unattended-upgrades unattended-upgrades/enable_auto_updates boolean true" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -f noninteractive unattended-upgrades

## Create Non-Root Sudo User
adduser --disabled-password --gecos "" "$desired_user"
echo "$desired_user:$Password" | chpasswd

## Prepare cleanup.sh & custom.sh
if [ "$bonus_features" = true ]; then
  mv custom.sh /home/$desired_user/
  chmod +x /home/$desired_user/custom.sh
  chown $desired_user:$desired_user /home/$desired_user/custom.sh
fi

if [ "$cleanup" = true ]; then
  mv cleanup.sh /home/$desired_user/
  chmod +x /home/$desired_user/cleanup.sh
  chown $desired_user:$desired_user /home/$desired_user/cleanup.sh
fi

## Setup User
usermod -aG sudo $desired_user && \
echo "$desired_user ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$desired_user && \
mv newuser.sh /home/$desired_user/ && chown $desired_user:$desired_user /home/$desired_user/newuser.sh && \
su - $desired_user -c "bash ~/newuser.sh"

## Finalise Cleanup
if [ "$cleanup" = true ]; then
  rm install.sh
  rm -rf ~/GZLockdown
fi
