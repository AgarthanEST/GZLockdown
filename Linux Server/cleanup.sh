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

## Cleanup

yes_or_no "Do you want all related non-root files cleaned?" && sudo rm ~/newuser.sh && sudo rm ~/cleanup.sh

#sudo rm ~/install.sh (When you can figure out priv escalation to clear root)
#sudo rm -rf ~/DIRECTORY_NAME
#Add directory name to the files above too

echo
echo "Setup Files Cleaned Successfully"
