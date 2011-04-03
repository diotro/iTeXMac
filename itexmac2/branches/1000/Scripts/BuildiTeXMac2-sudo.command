#!/bin/sh
# BuildiTeXMac2-sudo: use this to build iTeXMac2 from the command line
# XCode 2.2 compliant, version 1
sudo "$(echo "$0" | sed 's/-sudo\././')"
