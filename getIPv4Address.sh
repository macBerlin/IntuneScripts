#!/bin/zsh
# Michael Rieder 27.11.2023
ifconfig | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}' | cut -d ':' -f2 | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tr '\n' ';'
exit 0
