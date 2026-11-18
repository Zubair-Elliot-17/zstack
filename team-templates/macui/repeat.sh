#!/bin/bash
# repeat.sh <n> <gesture script> <bad-outcome check>: runs the gesture n times, counts how often the check succeeds.
# Example (drag into a dead zone): repeat.sh 5 ./drag.sh '[ -e ~/Desktop/photo.png ] && mv ~/Desktop/photo.png ~/qa/'
bad=0
for i in $(seq "$1"); do "$2"; sleep 1.5; eval "$3" && bad=$((bad+1)); done
echo "bad $bad of $1"
