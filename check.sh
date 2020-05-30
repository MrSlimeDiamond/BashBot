#!/bin/bash

cat ~/irclogs/zenoc/\#lobby | tail -1 | grep ".*?:.*? $*"
