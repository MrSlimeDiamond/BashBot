#!/bin/bash
source ./config.sh
screen -S $irssiScreenName -p 0 -X stuff "$*^M"
