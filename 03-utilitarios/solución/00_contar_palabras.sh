#!/bin/bash
python -m this| tr " " "\n" |tr [:upper:] [:lower:] |sort |uniq -c |sort -nr|head -5|awk '{print $2}'
