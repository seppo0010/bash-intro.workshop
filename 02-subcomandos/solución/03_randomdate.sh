#!/bin/bash
while true; do if [ $RANDOM -lt $((32767/2)) ]; then date; fi; sleep 1; done
