#!/bin/bash
#####################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
# Modified by Vaudois
# Modified by Itsgudenuf
#####################################################

echo
echo
echo -e "$CYAN => Check prerequisite : $COL_RESET"
echo

if [ "`lsb_release -d | sed 's/.*:\s*//' | sed 's/18\.04\.[0-9]/18.04/' `" == "Ubuntu 18.04 LTS" ]; then
  DISTRO=18
  sudo chmod g-w /etc /etc/default /usr
else 
  echo -e "$REDYiimP OOOOPS!!!!  It looks like you are trying to install on an unsupported Distro. \n $COL_RESET"
  exit
fi

ARCHITECTURE=$(uname -m)
if [ "$ARCHITECTURE" != "x86_64" ]; then
  if [ -z "$ARM" ]; then
    echo -e "$REDYiimP Install Script only supports x86_64 and will not work on any other architecture, like ARM or 32 bit OS. $COL_RESET"
    echo -e "$REDYour architecture is $ARCHITECTURE $COL_RESET"
    exit
  fi
fi

echo -e "$GREEN Done...$COL_RESET"