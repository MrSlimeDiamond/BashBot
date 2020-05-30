#!/bin/bash

cat /path/to/irssi/logs/server/\#channel | tail -1 | grep ".*?:.*? $*"
