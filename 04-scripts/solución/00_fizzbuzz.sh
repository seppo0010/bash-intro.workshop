#!/bin/bash
set -euo pipefail

filename="$(basename $0)"
num=$1
if [ $# -ne 1 ] || ! [[ $1 =~ ^[0-9]+$ ]] || ! [[ $filename =~ ^(fizz|buzz|fizzbuzz)$ ]]; then
    echo "usage: fizz <num>" 2>&1
    echo "usage: buzz <num>" 2>&1
    echo "usage: fizzbuzz <num>" 2>&1
    exit 1
fi


if [ $filename == "fizz" ] && [ $(( $1 % 3 )) -eq 0 ]; then
    echo "OK"
fi
if [ $filename == "buzz" ] && [ $(( $1 % 5 )) -eq 0 ]; then
    echo "OK"
fi
if [ $filename == "fizzbuzz" ] && [ $(( $1 % 15 )) -eq 0 ]; then
    echo "OK"
fi
