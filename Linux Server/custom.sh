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

## Customisations
echo
echo "*************************"
echo "CUSTOMISATIONS"
echo "*************************"
echo

echo "CONTEXT: An SSH Keypair allows passwordless login via generating a keyfile for authentication" 
echo "It is harder to brute force than a password"
echo
yes_or_no "Are you interested in creating an SSH Keypair?" && echo "TEST SUCCESSS"

echo
echo "CONTEXT: Ignoring pings mitigates the ping flood DDOS technique"
echo
yes_or_no "Do you want your server to ignore pings?" && echo "TEST SUCCESSS"

echo
yes_or_no "Do you want to geoblock IPs typically associated with spam?" && echo "TEST SUCCESSS"

enable2fa=false
echo
yes_or_no "Are you interested in setting up 2FA for SSH?" && enable2fa=true
if [ "$enable2fa" = true ]; then
  target_user="${SUDO_USER:-$(whoami)}"

  read -p "What do you want your 2FA entry to be called?: " 2fa_label
  sudo apt install libpam-google-authenticator -y
  sudo -u "$target_user" google-authenticator -t -d -f -r 3 -R 30 -w 1 -C -l "$2fa_label"

  grep -q '^ChallengeResponseAuthentication' /etc/ssh/sshd_config || echo 'ChallengeResponseAuthentication yes' >> /etc/ssh/sshd_config
  grep -q 'pam_google_authenticator.so' /etc/pam.d/sshd || echo 'auth required pam_google_authenticator.so' >> /etc/pam.d/sshd
  grep -q '^UsePAM' /etc/ssh/sshd_config || echo 'UsePAM yes' >> /etc/ssh/sshd_config

  # Force verification before continue?

  if sshd -t; then
    systemctl restart ssh
    echo
    echo "2FA Installation Success!"
  else
    echo "[ERROR] SSH config test failed! Aborting restart to prevent lockout."
    #exit 1
  fi
  
fi

echo
echo "CONTEXT: Fail2Ban detects malicious attacks and blocks the associated IP"
yes_or_no "Do you want to install Fail2Ban?" && echo "TEST SUCCESSS"

echo
#GET MORE OPTIONS IN HERE
