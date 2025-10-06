#!/bin/bash

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

## Setup
cd ~
mkdir ~/.ssh
chmod 700 ~/.ssh

## Customisation
echo "***********************"
read -p "Select Custom SSH Port: " desired_port

sudo sed -i "s/PermitRootLogin yes\b/PermitRootLogin no/gI" /etc/ssh/sshd_config # Block Root Login
sudo sed -i "s/#Port 22\b/Port $desired_port/gI" /etc/ssh/sshd_config # Unique SSH Port

sudo apt install ufw -y
sudo ufw limit $desired_port/tcp comment 'Rate limit on SSH attempts' # Firewall & SSH Protection
sudo systemctl restart ssh
sudo ufw --force enable
sudo ufw status

## Optional Features

echo
echo "CONTEXT: An SSH Keypair allows passwordless login via generating a keyfile for authentication" 
echo "It is harder to brute force than a password"
yes_or_no "Are you interested in creating an SSH Keypair?" && echo "TEST SUCCESSS"

# NOTE: Install other tools optionally here.

## Security
sudo apt-get autoremove -y # RM Useless Packages (Verify it runs, and doesn't just install. Then uninstall post run)
sudo rm /etc/sudoers.d/$USER # RM Passwordless Sudo Entry
(sleep 10 && /sbin/reboot) &

## Provide Login Details
myIP=$(curl -s ipinfo.io/ip)
echo
echo "----------------------------"
echo "ssh $USER@$myIP -p $desired_port"
echo "----------------------------"
echo
echo "Rebooting in 10 seconds..."

# NOTE: DDOS Protection will be needed. Look for tools. Protect externally with cloudflare. Get SSL cert etc.
# NOTE: This can be integrated into Auto Matrix setup. WIth custom site name, gets the SSL cert for you. ALL AUTOMATED.
# FEATURE: Set up SSH Keypair optional YN?
