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

echo
yes_or_no "Are you interested in setting up 2FA for SSH?" && echo "TEST SUCCESSS"

echo
echo "CONTEXT: Fail2Ban detects malicious attacks and blocks the associated IP"
yes_or_no "Do you want to install Fail2Ban?" && echo "TEST SUCCESSS"

echo
#GET MORE OPTIONS IN HERE
