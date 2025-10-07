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
#GET MORE OPTIONS IN HERE
