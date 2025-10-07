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
yes_or_no "Are you interested in creating an SSH Keypair?" && echo "TEST SUCCESSS"

echo
echo "CONTEXT: Ignoring pings mitigates the ping flood DDOS technique"
yes_or_no "Do you want your server to ignore pings?" && echo "TEST SUCCESSS"

echo
yes_or_no "Do you want to geoblock IPs typically associated with spam?" && echo "TEST SUCCESSS"

enable2fa=false
echo
yes_or_no "Are you interested in setting up 2FA for SSH?" && enable2fa=true
if [ "$enable2fa" = true ]; then
  OATH_FILE="/etc/security/users.oath"
  apt install -y libpam-oath oathtool
  
  mkdir -p "$(dirname "$OATH_FILE")"
  touch "$OATH_FILE"
  chmod 600 "$OATH_FILE"
  chown root:root "$OATH_FILE"

  PAM_FILE="/etc/pam.d/sshd"
  if ! grep -q "pam_oath.so" "$PAM_FILE"; then
    echo "auth required pam_oath.so usersfile=$OATH_FILE window=30 digits=6" >> "$PAM_FILE"
  fi
  
  SSHD_CONFIG="/etc/ssh/sshd_config"
  sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' "$SSHD_CONFIG"
  sed -i 's/^#*UsePAM.*/UsePAM yes/' "$SSHD_CONFIG"
  
  if sshd -t; then
    echo "[*] SSH config test passed, restarting SSH service..."
    systemctl restart ssh
    echo "[+] SSH 2FA setup complete and SSH restarted safely."
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
