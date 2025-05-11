#!/usr/bin/env bash
echo "$0 $1 $2"
echo $(($1+$2))
echo "hi $# $@"
arr=(`ls`)
echo "arr: $arr"
echo "arr[0]: ${arr[0]}"
echo "arr[1]: ${arr[1]}"
echo "--------------------"
#IFS=' '
arr=(`ls`)
echo "arr[0]-2: ${arr[0]}"
echo "----------------"
echo "arr[1]-2: ${arr[1]}"
echo "---------------"
