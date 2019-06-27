#!/bin/bash
ps aux |awk '{cpu = $3; pid = $2; $1="";$2="";$3="";$4="";$5="";$6="";$7="";$8="";$9="";$10=""; print cpu " " pid " " $0}' |sort -nr |head -10
