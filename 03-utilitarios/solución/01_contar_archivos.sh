#!/bin/bash
find . -type f |awk -F/ '{print $2}'| sort |uniq -c
